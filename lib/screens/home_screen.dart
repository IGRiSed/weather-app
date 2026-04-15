import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../theme/app_theme.dart';
import '../widgets/weather_main_card.dart';
import '../widgets/weather_details_grid.dart';
import '../widgets/sun_times_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/unit_toggle.dart';
import '../widgets/skeleton_loader.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController();

  WeatherData? _weather;
  WeatherData? _weatherCelsius;
  bool _isLoading = false;
  bool _isCelsius = true;
  String? _errorMessage;
  bool _isDarkMode = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _loadInitialData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    // Try to load cached data first
    final cached = await _weatherService.getCachedWeatherData();
    if (cached != null) {
      setState(() {
        _weatherCelsius = cached;
        _weather = cached;
      });
      _fadeController.forward();
    }

    // Then try GPS location
    await _fetchByLocation();
  }

  Future<void> _fetchByLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        // Fall back to last known city or default
        final lastCity = await _weatherService.getLastCity();
        if (lastCity != null) {
          await _fetchWeather(lastCity);
        } else {
          await _fetchWeather('Mumbai');
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );

      final data = await _weatherService.fetchWeatherByCoords(
        position.latitude,
        position.longitude,
      );

      _setWeather(data);
    } catch (e) {
      // Fallback to last city or default
      final lastCity = await _weatherService.getLastCity();
      if (lastCity != null) {
        await _fetchWeather(lastCity);
      } else if (_weather == null) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchWeather(String city) async {
    if (city.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _weatherService.fetchWeatherByCity(city);
      _setWeather(data);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _setWeather(WeatherData data) {
    _fadeController.reset();
    setState(() {
      _weatherCelsius = data;
      _weather = _isCelsius ? data : data.toFahrenheit();
      _isLoading = false;
      _errorMessage = null;
    });
    _fadeController.forward();
  }

  void _toggleUnit(bool isCelsius) {
    setState(() {
      _isCelsius = isCelsius;
      if (_weatherCelsius != null) {
        _weather = isCelsius
            ? _weatherCelsius!
            : _weatherCelsius!.toFahrenheit();
      }
    });
  }

  void _toggleDarkMode() {
    setState(() => _isDarkMode = !_isDarkMode);
    widget.onThemeChanged(_isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = _weather != null
        ? AppTheme.getGradientForCondition(_weather!.iconCode, isDark)
        : (isDark
            ? [const Color(0xFF0A1628), const Color(0xFF1A237E)]
            : [const Color(0xFF1A73E8), const Color(0xFF42A5F5)]);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(isDark),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          const Icon(Icons.cloud, color: Colors.white, size: 28),
          const SizedBox(width: 8),
          const Text(
            'WeatherNow',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _toggleDarkMode,
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            tooltip: 'Toggle Dark Mode',
          ),
          IconButton(
            onPressed: _fetchByLocation,
            icon: const Icon(Icons.my_location, color: Colors.white),
            tooltip: 'Use my location',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        if (_weather != null) {
          await _fetchWeather(_weather!.cityName);
        } else {
          await _fetchByLocation();
        }
      },
      color: Colors.white,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            SearchBarWidget(
              controller: _searchController,
              onSearch: (city) {
                _searchController.clear();
                FocusScope.of(context).unfocus();
                _fetchWeather(city);
              },
            ),
            const SizedBox(height: 8),
            UnitToggle(
              isCelsius: _isCelsius,
              onToggle: _toggleUnit,
            ),
            const SizedBox(height: 16),
            if (_isLoading && _weather == null)
              const SkeletonLoader()
            else if (_errorMessage != null && _weather == null)
              _buildErrorWidget()
            else if (_weather != null)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    WeatherMainCard(
                      weather: _weather!,
                      isCelsius: _isCelsius,
                    ),
                    const SizedBox(height: 16),
                    WeatherDetailsGrid(weather: _weather!),
                    const SizedBox(height: 16),
                    SunTimesCard(weather: _weather!),
                    const SizedBox(height: 16),
                    _buildLastUpdated(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off, color: Colors.white, size: 64),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'Something went wrong',
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchByLocation,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    if (_weather == null) return const SizedBox.shrink();
    final time = _weather!.lastUpdated;
    final formatted =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return Text(
      'Last updated: $formatted',
      style: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: 12,
      ),
    );
  }
}
