import 'package:flutter/material.dart';
import 'package:sub_screen_example/widgets/shared_counter.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Page'),
      ),
      body: const Center(
        child: SharedCounterView(),
      ),
    );
  }
}
