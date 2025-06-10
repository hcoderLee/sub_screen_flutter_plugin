import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sub_screen/utils.dart';

typedef OnSharedStateChangeListener = void Function(Map<String, dynamic>?);

const _sharedStateChannelName =
    "com.hcoderlee.subscreen.sub_screen/shared_state";

abstract class SharedState<T> extends ChangeNotifier {
  T? _state;

  T? get state => _state;

  late final Future initialSync;
  bool _isSyncComplete = false;

  SharedState() : super() {
    SharedStateManager.instance.addStateChangeListener(
      runtimeType.toString(),
      _onStateChange,
    );
    _state = build();
    initialSync = _syncState();
  }

  void setState(T? state) async {
    // Make sure initial value synchronization complete
    if (!_isSyncComplete) {
      await initialSync;
    }

    SharedStateManager.instance.updateState(
      runtimeType.toString(),
      toJson(state),
    );
  }

  void clearState() async {
    if (!_isSyncComplete) {
      await initialSync;
    }
    SharedStateManager.instance.clearState(runtimeType.toString());
  }

  /// Synchronizing the latest state for current type
  Future _syncState() async {
    final json = await SharedStateManager.instance.getState(
      runtimeType.toString(),
    );
    _isSyncComplete = true;

    if (json != null) {
      _onStateChange(json);
    }
  }

  void _onStateChange(Map<String, dynamic>? data) {
    try {
      if (data == null) {
        _state = null;
      } else {
        _state = fromJson(data);
      }
      notifyListeners();
    } catch (e) {
      throw Exception(
        "SharedState failed to parse for $runtimeType from: $data, $e",
      );
    }
  }

  @override
  void dispose() {
    SharedStateManager.instance.removeStateChangeListener(
      runtimeType.toString(),
      _onStateChange,
    );
    super.dispose();
  }

  T fromJson(Map<String, dynamic> json);

  Map<String, dynamic>? toJson(T? data);

  /// Create the initial state value for current type. It make sure to use the same
  /// initial value in different flutter engine
  /// Return an immutable object and without refer to fields that are variant in
  /// different flutter engine
  T? build() {
    return null;
  }
}

class SharedStateManager {
  static SharedStateManager? _instance;

  static SharedStateManager get instance {
    _instance ??= SharedStateManager._();
    return _instance!;
  }

  final Map<String, Set<OnSharedStateChangeListener>> _listeners = {};
  late final MethodChannel methodChannel;

  SharedStateManager._() {
    _initMethodChannel();
  }

  void _initMethodChannel() {
    methodChannel = const MethodChannel(_sharedStateChannelName);
    methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onStateChanged':
          final type = call.arguments['type'] as String?;
          assert(type != null);
          final rawData = call.arguments['data'];
          final data = rawData != null ? convertMapToJson(rawData) : null;
          _notifyListeners(type!, data);
          break;
        default:
          throw "SharedStateManager: Unknown method ${call.method}";
      }
    });
  }

  Future<Map<String, dynamic>?> getState(String type) async {
    final result = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'getState',
      {'type': type},
    );
    if (result == null) {
      return null;
    }
    return convertMapToJson(result);
  }

  Future<void> updateState(String type, Map<String, dynamic>? data) async {
    try {
      await methodChannel.invokeMethod('updateState', {
        'type': type,
        'state': data,
      });
    } on PlatformException catch (e) {
      debugPrint('Error updating shared state: ${e.message}');
    }
  }

  Future<void> clearState(String type) async {
    try {
      await methodChannel.invokeMethod('clearState', {'type': type});
    } on PlatformException catch (e) {
      debugPrint('Error clear shared state: ${e.message}');
    }
  }

  void addStateChangeListener(
    String type,
    OnSharedStateChangeListener listener,
  ) {
    _listeners.putIfAbsent(type, () => {});
    _listeners[type]!.add(listener);
  }

  void removeStateChangeListener<T>(
    String type,
    OnSharedStateChangeListener listener,
  ) {
    final stateListeners = _listeners[type];
    if (stateListeners == null || stateListeners.isEmpty) {
      return;
    }
    stateListeners.remove(listener);
  }

  void _notifyListeners(String type, Map<String, dynamic>? data) {
    final listeners = _listeners[type];
    if (listeners != null) {
      for (final listener in listeners) {
        listener(data);
      }
    }
  }
}
