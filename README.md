# ☁️ WeatherNow - Flutter Android App

A beautiful, real-time weather app built with Flutter/Dart, inspired by the WeatherApp PPT presentation.

---

## 📱 Features

| Feature | Description |
|---|---|
| 🌡️ Live Temperature | Current, feels-like, min/max |
| 💧 Humidity Tracking | Real-time moisture levels |
| 💨 Wind Speed & Direction | Speed + compass direction |
| ☁️ Cloud Coverage | Sky condition with description |
| 🔭 Visibility Range | Clear vs foggy conditions |
| 🌅 Sunrise & Sunset | With animated sun arc progress |
| 🌙 Dark Mode | Toggle dark/light theme |
| 🌡️ °C / °F Toggle | Instant unit conversion |
| 📍 GPS Location | Auto-detect user location |
| 🔄 Pull to Refresh | Refresh weather data |
| 💾 Offline Cache | Shows last known weather offline |
| 💀 Skeleton Loading | Smooth loading placeholders |

---

## 🚀 Setup Instructions

### 1. Prerequisites
- Flutter SDK 3.x installed → https://flutter.dev/docs/get-started/install
- Android Studio or VS Code with Flutter plugin
- Android device or emulator (API 21+)

### 2. Get API Key
1. Go to https://openweathermap.org/api
2. Sign up for free → get your API key
3. Free tier: 60 req/min, 1M req/month ✅

### 3. Add Your API Key
Open `lib/services/weather_service.dart` and replace:
```dart
static const String _apiKey = 'YOUR_API_KEY_HERE';
```
with your actual OpenWeatherMap API key.

### 4. Run the App
```bash
# Clone or download the project
cd weather_app

# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Build APK for Android
flutter build apk --release
```

The release APK will be at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🏗️ Architecture

```
lib/
├── main.dart                    # App entry point, theme management
├── models/
│   └── weather_model.dart       # WeatherData model + JSON parsing
├── services/
│   └── weather_service.dart     # OpenWeatherMap API + caching
├── screens/
│   └── home_screen.dart         # Main screen with state management
├── widgets/
│   ├── weather_main_card.dart   # Big temperature + condition card
│   ├── weather_details_grid.dart # 6-item metrics grid
│   ├── sun_times_card.dart      # Sunrise/sunset with arc animation
│   ├── search_bar_widget.dart   # City search input
│   ├── unit_toggle.dart         # °C / °F toggle
│   └── skeleton_loader.dart     # Loading placeholder
└── theme/
    └── app_theme.dart           # Light/dark themes + weather gradients
```

---

## 🔧 Tech Stack

| Tech | Purpose |
|------|---------|
| Flutter/Dart | Cross-platform mobile UI |
| OpenWeatherMap API | Live weather data |
| `geolocator` | GPS location detection |
| `http` | HTTP requests |
| `shared_preferences` | Local cache storage |
| `intl` | Date/time formatting |

---

## 🔐 Android Permissions

The app requests:
- `INTERNET` — for API calls
- `ACCESS_FINE_LOCATION` — for GPS weather
- `ACCESS_COARSE_LOCATION` — fallback location

---

## 🗺️ Future Enhancements (from PPT)

- **Phase 1**: 7-Day Forecast, Hourly Breakdown, UV Index
- **Phase 2**: Weather Alerts, Map Integration, AQI
- **Phase 3**: ML Predictions, Favorite Locations, Wearable Support

---

Built with ❤️ using Flutter • Powered by OpenWeatherMap
