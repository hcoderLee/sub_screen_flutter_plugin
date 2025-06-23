import 'package:sub_screen/shared_state_manager.dart';

class Counter {
  final int count;

  Counter(this.count);
}

class SharedCounterState extends SharedState<Counter> {
  @override
  Counter fromJson(Map<String, dynamic> json) {
    final count = json['count'] as int;
    return Counter(count);
  }

  @override
  Map<String, dynamic>? toJson(Counter? data) {
    if (data == null) {
      return null;
    }
    return {'count': data.count};
  }
}
