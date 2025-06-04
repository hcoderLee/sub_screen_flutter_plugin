import 'package:flutter/material.dart';
import 'package:sub_screen/model.dart';
import 'package:sub_screen/sub_screen.dart';
import 'package:sub_screen_example/widgets/animation_box.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int? _subDisplayId;

  bool get hasSecondaryDisplay => _subDisplayId != null;

  @override
  void initState() {
    super.initState();
    SubScreenPlugin.setOnMultiDisplayListener(OnMultiDisplayListener(
      onDisplayAdded: (Display display) {
        if (!display.isDefault) {
          setState(() {
            _subDisplayId = display.id;
          });
        }
      },
      onDisplayChanged: (Display display) {},
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
      appBar: AppBar(
        title: const Text('MainScreen Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is main screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            if (hasSecondaryDisplay) ...[
              const SizedBox(height: 50),
              const AnimationBox(),
            ] else ...[
              const Text('No sub display found'),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }
}
