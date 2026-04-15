import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final WeatherData weather;

  const WeatherDetailsGrid({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final items = [
      _DetailItem(
        icon: Icons.water_drop,
        label: 'Humidity',
        value: '${weather.humidity}%',
        color: const Color(0xFF4FC3F7),
      ),
      _DetailItem(
        icon: Icons.air,
        label: 'Wind Speed',
        value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
        color: const Color(0xFF80DEEA),
      ),
      _DetailItem(
        icon: Icons.explore,
        label: 'Wind Dir',
        value: weather.windDirection,
        color: const Color(0xFFB39DDB),
      ),
      _DetailItem(
        icon: Icons.cloud,
        label: 'Cloud Cover',
        value: '${weather.cloudCoverage}%',
        color: const Color(0xFFB0BEC5),
      ),
      _DetailItem(
        icon: Icons.visibility,
        label: 'Visibility',
        value: '${weather.visibility.toStringAsFixed(1)} km',
        color: const Color(0xFF80CBC4),
      ),
      _DetailItem(
        icon: Icons.thermostat,
        label: 'Feels Like',
        value: '${weather.feelsLike.round()}°',
        color: const Color(0xFFFFCC02),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildDetailCard(items[index]),
    );
  }

  Widget _buildDetailCard(_DetailItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: item.color, size: 28),
          const SizedBox(height: 6),
          Text(
            item.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
