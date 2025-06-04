class Display {
  final int id;
  final String name;
  final int width;
  final int height;
  final double refreshRate;
  final bool isDefault;

  Display({
    required this.id,
    required this.name,
    required this.width,
    required this.height,
    required this.refreshRate,
    required this.isDefault,
  });

  factory Display.fromMap(Map<String, dynamic> map) {
    return Display(
      id: map['id'] as int,
      name: map['name'] as String,
      width: map['width'] as int,
      height: map['height'] as int,
      refreshRate: map['refreshRate'] as double,
      isDefault: map['isDefault'] as bool,
    );
  }

  @override
  String toString() {
    return 'Display{id: $id, name: $name, width: $width, height: $height, refreshRate: $refreshRate, isDefault: $isDefault}';
  }
}

class OnMultiDisplayListener {
  final Function(Display display) onDisplayAdded;

  final Function(Display display) onDisplayChanged;

  final Function(int displayId) onDisplayRemoved;

  OnMultiDisplayListener({
    required this.onDisplayAdded,
    required this.onDisplayChanged,
    required this.onDisplayRemoved,
  });
}
