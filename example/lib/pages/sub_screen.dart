import 'package:flutter/material.dart';
import 'package:sub_screen_example/widgets/animation_box.dart';

class SubScreen extends StatefulWidget {
  const SubScreen({super.key});

  @override
  State<SubScreen> createState() => _SubScreenState();
}

class _SubScreenState extends State<SubScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SubScreen Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is sub screen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 50),
            const AnimationBox(),
          ],
        ),
      ),
    );
  }
}
