enum DeviceType { light, climate, socket, sensor, lock }

// Кімнати, в яких можна розмістити пристрій.
abstract final class DeviceRooms {
  static const List<String> values = [
    'Вітальня',
    'Спальня',
    'Кухня',
    'Ванна',
    'Коридор',
  ];
}

// Розумний пристрій. Незмінний: будь-яка зміна створює нову копію.
class Device {
  const Device({
    required this.id,
    required this.name,
    required this.room,
    required this.type,
    required this.isOn,
  });

  final String id;
  final String name;
  final String room;
  final DeviceType type;
  final bool isOn;

  Device copyWith({String? name, String? room, DeviceType? type, bool? isOn}) {
    return Device(
      id: id,
      name: name ?? this.name,
      room: room ?? this.room,
      type: type ?? this.type,
      isOn: isOn ?? this.isOn,
    );
  }
}

// Дані з форми створення / редагування пристрою.
typedef DeviceDraft = ({String name, String room, DeviceType type});
