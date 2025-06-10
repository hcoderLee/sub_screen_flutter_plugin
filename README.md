# sub_screen

A Flutter plugin that provides dual-screen support and shared state management across different
Flutter engines.

## Features

- **Dual-screen Support**: Monitor and manage dual displays on Android devices
- **Display Events**: Listen to display changes (added, removed, or modified)
- **State Persistence**: Maintain state consistency across different displays

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  sub_screen: ^0.1.0
```

## Android Configuration

To support dual-screen functionality in your Android app, you need to:

1. Extend `MultiDisplayFlutterActivity` in your main activity:

```kotlin
// MainActivity.kt
import com.hcoderlee.subscreen.sub_screen.MultiDisplayFlutterActivity

class MainActivity : MultiDisplayFlutterActivity() {
    /**
     * Returns the name of the Flutter entry point function for the secondary display. If not overridden,
     * defaults to "subScreenEntry"
     */
    override fun getSubScreenEntryPoint(): String {
        return "subDisplay"
    }
}
```

2. Create a secondary entry point in your Flutter app:

```dart
// main.dart
void main() {
  runApp(const MyApp());
}

// Secondary entry point for the second display
@pragma('vm:entry-point') // Required: This annotation ensures the function is preserved during tree-shaking
void subDisplay() {
  runApp(const MySecondaryApp());
}
```

The plugin uses Android's `Presentation` class to render content on the secondary display. When a
secondary display is connected, the plugin automatically creates a new Flutter engine instance and
renders your secondary app using the specified entry point function.

## Usage

### Dual-screen Support

```dart
import 'package:sub_screen/sub_screen.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int? _subDisplayId;

  bool get hasSecondaryDisplay => _subDisplayId != null;

  @override
  void initState() {
    super.initState();
    // Set up display change listeners
    SubScreenPlugin.setOnMultiDisplayListener(OnMultiDisplayListener(
      onDisplayAdded: (Display display) {
        if (!display.isDefault) {
          setState(() {
            _subDisplayId = display.id;
          });
        }
      },
      onDisplayChanged: (Display display) {
        // Handle display changes
      },
      onDisplayRemoved: (int displayId) {
        if (displayId == _subDisplayId) {
          setState(() {
            _subDisplayId = null;
          });
        }
      },
    ));
    _checkSecondaryDisplay();
  }

  Future<void> _checkSecondaryDisplay() async {
    // Get all available displays
    final displays = await SubScreenPlugin.getDisplays();
    for (var display in displays) {
      if (!display.isDefault) {
        setState(() {
          _subDisplayId = display.id;
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(hasSecondaryDisplay
                ? 'Secondary display connected'
                : 'No secondary display found'
            ),
            // Your widget content
          ],
        ),
      ),
    );
  }
}
```

### Shared State Management

The shared state system works by maintaining a one-to-one relationship between each `SharedState`
class and its corresponding state data. Each class that extends `SharedState` represents a unique
type of state that can be shared across different Flutter engines.

```dart
import 'package:sub_screen/shared_state_manager.dart';

// Define your data model
class Counter {
  final int count;

  Counter(this.count);

  factory Counter.fromJson(Map<String, dynamic> json) {
    return Counter(json['count'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'count': count};
  }
}

// Create a shared state class
class CounterState extends SharedState<Counter> {
  @override
  Counter fromJson(Map<String, dynamic> json) {
    return Counter.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(Counter? data) {
    return data?.toJson();
  }

  @override
  Counter? build() {
    // Return an unmodifiable initial state
    // This ensures consistent initial state across different Flutter engines
    return Counter(0);
  }
}

// Use the shared state
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final CounterState _counterState;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _counterState = CounterState();
    _count = _counterState.state?.count ?? 0;

    // Listen to state changes
    _counterState.addListener(() {
      setState(() {
        _count = _counterState.state?.count ?? 0;
      });
    });
  }

  void _increment() {
    _counterState.setState(Counter(_count + 1));
  }

  @override
  void dispose() {
    // Important: Always dispose the shared state when done
    _counterState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $_count'),
        ElevatedButton(
          onPressed: _increment,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

## Platform Support

This plugin is only support Android platform for now

## License

This project is licensed under the MIT License - see the LICENSE file for details.

