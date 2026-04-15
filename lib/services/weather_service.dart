import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class WeatherService {
  // Replace with your OpenWeatherMap API key
  static const String _apiKey = 'YOUR_API_KEY_HERE';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _cacheKey = 'cached_weather';
  static const String _cacheCityKey = 'cached_city';

  /// Fetch weather by city name with debounce/cache support
  Future<WeatherData> fetchWeatherByCity(String city) async {
    if (city.trim().isEmpty) throw Exception('Please enter a city name.');

    final url = Uri.parse(
        '$_baseUrl/weather?q=${Uri.encodeComponent(city)}&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weather = WeatherData.fromJson(data);
        await _cacheWeather(response.body, city);
        return weather;
      } else if (response.statusCode == 404) {
        throw Exception('City "$city" not found. Please check the spelling.');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your configuration.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Exception')) rethrow;
      // Network error - try cache
      return await _getCachedWeather() ??
          (throw Exception('No internet connection. No cached data available.'));
    }
  }

  /// Fetch weather by coordinates (GPS)
  Future<WeatherData> fetchWeatherByCoords(double lat, double lon) async {
    final url = Uri.parse(
        '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weather = WeatherData.fromJson(data);
        await _cacheWeather(response.body, weather.cityName);
        return weather;
      } else {
        throw Exception('Failed to get weather for your location.');
      }
    } catch (e) {
      if (e.toString().contains('Exception')) rethrow;
      return await _getCachedWeather() ??
          (throw Exception('Could not fetch weather data.'));
    }
  }

  Future<void> _cacheWeather(String jsonStr, String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonStr);
    await prefs.setString(_cacheCityKey, city);
    await prefs.setInt('cache_time', DateTime.now().millisecondsSinceEpoch);
  }

  Future<WeatherData?> _getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKey);
    if (cached == null) return null;
    return WeatherData.fromJson(json.decode(cached));
  }

  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cacheCityKey);
  }

  Future<WeatherData?> getCachedWeatherData() => _getCachedWeather();
}
