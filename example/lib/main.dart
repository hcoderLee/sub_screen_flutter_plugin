import 'package:flutter/material.dart';
import 'package:sub_screen_example/pages/main_screen.dart';

import 'pages/sub_screen.dart';

enum DisplayType {
  main,
  external,
}

late final DisplayType displayType;

void main() {
  displayType = DisplayType.main;
  runApp(const Main());
}

@pragma('vm:entry-point')
void subScreenEntry() {
  displayType = DisplayType.external;
  runApp(const External());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MultiScreen Demo",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class External extends StatelessWidget {
  const External({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SubScreen(),
    );
  }
}
