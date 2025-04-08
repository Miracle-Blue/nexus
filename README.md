<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Nexus

A powerful Flutter debug overlay for monitoring network requests in real-time. Nexus provides a convenient slide-out panel that shows all network interactions from your Dio HTTP clients.

<div style="display: flex; flex-direction: row; flex-wrap: wrap; gap: 10px;">
  <img src="https://github.com/Miracle-Blue/nexus/blob/dev/screenshots/screenshot_1.png" alt="Nexus Overview" width="24%" />
  <img src="https://github.com/Miracle-Blue/nexus/blob/dev/screenshots/screenshot_2.png" alt="Nexus Request Details" width="24%" />
  <img src="https://github.com/Miracle-Blue/nexus/blob/dev/screenshots/screenshot_3.png" alt="Nexus Response View" width="24%" />
  <img src="https://github.com/Miracle-Blue/nexus/blob/dev/screenshots/screenshot_4.png" alt="Nexus Search Feature" width="24%" />
</div>

## Features

- 📱 **Simple Integration** - Add a single widget to your app
- 🔍 **Network Monitoring** - Track all requests and responses from Dio instances
- 🔎 **Search & Filter** - Easily find specific network calls
- 🗑️ **Clear Logs** - One-tap to remove all logs
- 👆 **Interactive UI** - Slide-out panel with intuitive controls
- 🛠️ **Debug Mode Only** - Automatically disabled in release builds
- 📊 **Request Details** - View headers, payloads, and responses

## Installation

Add Nexus to your `pubspec.yaml`:

```yaml
dependencies:
  nexus: ^1.0.0  # Replace with actual version
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Setup

Wrap your app with the `Nexus` widget to start monitoring network requests:

```dart
import 'package:nexus/nexus.dart';
import 'package:dio/dio.dart';

void main() {
  // Your Dio instances
  final dio1 = Dio();
  final dio2 = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  runApp(MyApp(dio1: dio1, dio2: dio2));
}

class MyApp extends StatelessWidget {
  final Dio dio1;
  final Dio dio2;

  const MyApp({Key? key, required this.dio1, required this.dio2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: const HomePage(),
      builder: (context, child) => Nexus(
        dio: [dio1, dio2],
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
```

### How to Use

1. Run your app in debug mode
2. Tap the green handle on the left side of the screen to reveal the Nexus panel
3. Make network requests in your app to see them appear in the panel
4. Use the search button to find specific requests
5. Use the filter button to sort requests
6. Use the delete button to clear all logs

## Configuration

Nexus can be customized with these parameters:

```dart
Nexus(
  // Required: Your app's main widget
  child: yourAppWidget,

  // Optional: List of Dio instances to monitor
  dio: [dio1, dio2],

  // Optional: Enable/disable the overlay (defaults to kDebugMode)
  enable: true,

  // Optional: Animation duration for the slide-out panel
  duration: const Duration(milliseconds: 250),
);
```

## How It Works

Nexus attaches to your Dio instances and intercepts all network requests and responses. The data is displayed in a user-friendly interface that can be accessed by tapping the handle on the side of your app.

The overlay shows:
- Request method (GET, POST, etc.)
- URL
- Status code
- Response time
- Request and response headers
- Request and response bodies

## Example Project

For a complete working example, check the [example](https://github.com/username/nexus/tree/main/example) directory.

## Contributing

Contributions are welcome! If you find a bug or want a feature, please:

1. Check if an issue already exists
2. Create a new issue if needed
3. Fork the repo
4. Create your feature branch (`git checkout -b feature/amazing-feature`)
5. Commit your changes (`git commit -m 'Add some amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
