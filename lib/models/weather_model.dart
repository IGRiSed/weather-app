class WeatherData {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final String windDirection;
  final String description;
  final String iconCode;
  final int cloudCoverage;
  final double visibility;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime lastUpdated;
  final double lat;
  final double lon;

  WeatherData({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.windDirection,
    required this.description,
    required this.iconCode,
    required this.cloudCoverage,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.lastUpdated,
    required this.lat,
    required this.lon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final wind = json['wind'] ?? {};
    final main = json['main'] ?? {};
    final weather = (json['weather'] as List?)?.first ?? {};
    final sys = json['sys'] ?? {};
    final clouds = json['clouds'] ?? {};

    return WeatherData(
      cityName: json['name'] ?? 'Unknown',
      country: sys['country'] ?? '',
      temperature: (main['temp'] ?? 0).toDouble(),
      feelsLike: (main['feels_like'] ?? 0).toDouble(),
      tempMin: (main['temp_min'] ?? 0).toDouble(),
      tempMax: (main['temp_max'] ?? 0).toDouble(),
      humidity: (main['humidity'] ?? 0).toInt(),
      windSpeed: (wind['speed'] ?? 0).toDouble(),
      windDeg: (wind['deg'] ?? 0).toInt(),
      windDirection: _degToCompass((wind['deg'] ?? 0).toInt()),
      description: weather['description'] ?? '',
      iconCode: weather['icon'] ?? '01d',
      cloudCoverage: (clouds['all'] ?? 0).toInt(),
      visibility: ((json['visibility'] ?? 10000) / 1000).toDouble(),
      sunrise: DateTime.fromMillisecondsSinceEpoch((sys['sunrise'] ?? 0) * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch((sys['sunset'] ?? 0) * 1000),
      lastUpdated: DateTime.now(),
      lat: (json['coord']?['lat'] ?? 0).toDouble(),
      lon: (json['coord']?['lon'] ?? 0).toDouble(),
    );
  }

  static String _degToCompass(int deg) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return dirs[((deg + 22.5) / 45).floor() % 8];
  }

  WeatherData toCelsius() => this;

  WeatherData toFahrenheit() {
    return WeatherData(
      cityName: cityName,
      country: country,
      temperature: _cToF(temperature),
      feelsLike: _cToF(feelsLike),
      tempMin: _cToF(tempMin),
      tempMax: _cToF(tempMax),
      humidity: humidity,
      windSpeed: windSpeed,
      windDeg: windDeg,
      windDirection: windDirection,
      description: description,
      iconCode: iconCode,
      cloudCoverage: cloudCoverage,
      visibility: visibility,
      sunrise: sunrise,
      sunset: sunset,
      lastUpdated: lastUpdated,
      lat: lat,
      lon: lon,
    );
  }

  static double _cToF(double c) => c * 9 / 5 + 32;

  String get formattedDescription =>
      description[0].toUpperCase() + description.substring(1);
}
