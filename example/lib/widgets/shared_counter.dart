import 'package:flutter/material.dart';
import 'package:sub_screen_example/model.dart';

class SharedCounterView extends StatefulWidget {
  const SharedCounterView({super.key});

  @override
  State<SharedCounterView> createState() => _SharedCounterViewState();
}

class _SharedCounterViewState extends State<SharedCounterView> {
  final _sharedCounter = SharedCounterState();
  int _counter = 0;

  @override
  void initState() {
    _counter = _sharedCounter.state?.count ?? 0;
    super.initState();
    _sharedCounter.addListener(() {
      final counter = _sharedCounter.state;
      setState(() {
        _counter = counter?.count ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _counter.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(width: 20),
        IconButton(onPressed: _increment, icon: const Icon(Icons.add)),
        IconButton(onPressed: _clear, icon: const Icon(Icons.clear))
      ],
    );
  }

  void _increment() {
    _sharedCounter.setState(Counter(_counter + 1));
  }

  void _clear() {
    _sharedCounter.clearState();
  }

  @override
  void dispose() {
    _sharedCounter.dispose();
    super.dispose();
  }
}
