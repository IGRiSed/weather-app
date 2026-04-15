import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherMainCard extends StatelessWidget {
  final WeatherData weather;
  final bool isCelsius;

  const WeatherMainCard({
    super.key,
    required this.weather,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    final unit = isCelsius ? '°C' : '°F';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 18),
              const SizedBox(width: 4),
              Text(
                '${weather.cityName}, ${weather.country}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Weather icon from OpenWeatherMap
          Image.network(
            'https://openweathermap.org/img/wn/${weather.iconCode}@4x.png',
            width: 120,
            height: 120,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.wb_cloudy,
              size: 80,
              color: Colors.white,
            ),
          ),
          Text(
            '${weather.temperature.round()}$unit',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w300,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            weather.formattedDescription,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _tempPill('Feels like', '${weather.feelsLike.round()}$unit'),
              const SizedBox(width: 12),
              _tempPill('H: ${weather.tempMax.round()}$unit', 'L: ${weather.tempMin.round()}$unit'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tempPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label  $value',
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}
