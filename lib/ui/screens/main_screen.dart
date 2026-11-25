import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_home_app/domain/entities/device.dart';
import 'package:smart_home_app/domain/entities/sensor_reading.dart';
import 'package:smart_home_app/domain/entities/user.dart';
import 'package:smart_home_app/domain/repositories/auth_repository.dart';
import 'package:smart_home_app/domain/repositories/device_repository.dart';
import 'package:smart_home_app/ui/routes/app_routes.dart';
import 'package:smart_home_app/ui/theme/app_spacing.dart';
import 'package:smart_home_app/ui/widgets/app_snack_bar.dart';
import 'package:smart_home_app/ui/widgets/confirm_dialog.dart';
import 'package:smart_home_app/ui/widgets/dashboard_content.dart';
import 'package:smart_home_app/ui/widgets/device_form_sheet.dart';
import 'package:smart_home_app/ui/widgets/user_avatar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    required this.authRepository,
    required this.deviceRepository,
    super.key,
  });

  final IAuthRepository authRepository;
  final IDeviceRepository deviceRepository;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User? _user;
  List<Device> _devices = const [];
  List<SensorReading> _sensors = const [];
  bool _isLoading = true;

  IDeviceRepository get _repo => widget.deviceRepository;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = await widget.authRepository.getCurrentUser();
    if (!mounted) return;
    if (user == null) return context.go(AppRoutes.login);

    final devices = await _repo.getDevices(user.email);
    final sensors = await _repo.getSensorReadings();
    if (!mounted) return;
    setState(() {
      _user = user;
      _devices = devices;
      _sensors = sensors;
      _isLoading = false;
    });
  }

  Future<void> _toggle(Device device, bool isOn) async {
    final updated = device.copyWith(isOn: isOn);
    setState(() => _replace(updated));
    await _repo.updateDevice(_user!.email, updated);
  }

  Future<void> _openForm({Device? device}) async {
    final result = await showDeviceFormSheet(context, device: device);
    if (result == null || !mounted) return;

    final email = _user!.email;
    switch ((result, device)) {
      case (DeviceFormSaved(:final draft), null):
        final created = await _repo.addDevice(email, draft);
        setState(() => _devices = [..._devices, created]);
        _notify('Пристрій «${created.name}» додано');
      case (DeviceFormSaved(:final draft), final Device existing):
        final updated = existing.copyWith(
          name: draft.name,
          room: draft.room,
          type: draft.type,
        );
        await _repo.updateDevice(email, updated);
        setState(() => _replace(updated));
        _notify('Зміни збережено');
      case (DeviceFormDeleted(), final Device existing):
        await _delete(existing);
      case (DeviceFormDeleted(), null):
        break;
    }
  }

  Future<void> _delete(Device device) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Видалити пристрій?',
      message: '«${device.name}» буде видалено без можливості відновлення.',
    );
    if (!confirmed) return;
    await _repo.deleteDevice(_user!.email, device.id);
    setState(
      () => _devices = _devices.where((d) => d.id != device.id).toList(),
    );
    _notify('Пристрій видалено');
  }

  void _replace(Device device) {
    _devices = [for (final d in _devices) d.id == device.id ? device : d];
  }

  void _notify(String message) {
    if (mounted) showAppSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user == null ? 'Smart Home' : 'Привіт, ${user.firstName}!'),
        actions: [
          if (user != null)
            IconButton(
              tooltip: 'Профіль',
              onPressed: () async {
                await context.push(AppRoutes.profile);
                await _load(); // імʼя могло змінитись у профілі
              },
              icon: UserAvatar(initials: user.initials, radius: 18),
            ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton.extended(
              onPressed: _openForm,
              icon: const Icon(Icons.add),
              label: const Text('Додати'),
            ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : DashboardContent(
                sensors: _sensors,
                devices: _devices,
                onToggle: _toggle,
                onEdit: (device) => _openForm(device: device),
              ),
      ),
    );
  }
}
