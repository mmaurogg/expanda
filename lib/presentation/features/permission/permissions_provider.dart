import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionsProvider =
    StateNotifierProvider<PermissionsNotifier, PermissionsState>(
      (ref) => PermissionsNotifier(),
    );

class PermissionsNotifier extends StateNotifier<PermissionsState> {
  PermissionsNotifier() : super(PermissionsState());

  Future<void> checkPermissions() async {
    final permissions = PermissionsState(
      camera: await Permission.camera.status,
      photoLibrary: await Permission.photos.status,
      sensors: await Permission.sensors.status,
      location: await Permission.location.status,
      locationAlways: await Permission.locationAlways.status,
      locationWhenInUse: await Permission.locationWhenInUse.status,
    );
  }

  void showSettingsScreen(PermissionStatus status) {
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    state = state.copyWith(camera: status);

    showSettingsScreen(status);
  }

  Future<void> requestPhotoLibraryPermission() async {
    final status = await Permission.photos.request();
    state = state.copyWith(photoLibrary: status);

    showSettingsScreen(status);
  }

  Future<void> requestSensorsPermission() async {
    final status = await Permission.sensors.request();
    state = state.copyWith(sensors: status);

    showSettingsScreen(status);
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    state = state.copyWith(location: status);

    showSettingsScreen(status);
  }

  Future<void> requestLocationAlwaysPermission() async {
    final status = await Permission.locationAlways.request();
    state = state.copyWith(locationAlways: status);

    showSettingsScreen(status);
  }

  Future<void> requestLocationWhenInUsePermission() async {
    final status = await Permission.locationWhenInUse.request();
    state = state.copyWith(locationWhenInUse: status);

    showSettingsScreen(status);
  }
}

class PermissionsState {
  final PermissionStatus camera;
  final PermissionStatus photoLibrary;
  final PermissionStatus sensors;

  final PermissionStatus location;
  final PermissionStatus locationAlways;
  final PermissionStatus locationWhenInUse;

  PermissionsState({
    this.camera = PermissionStatus.denied,
    this.photoLibrary = PermissionStatus.denied,
    this.sensors = PermissionStatus.denied,
    this.location = PermissionStatus.denied,
    this.locationAlways = PermissionStatus.denied,
    this.locationWhenInUse = PermissionStatus.denied,
  });

  bool get cameraGranted => camera == PermissionStatus.granted;
  bool get photoLibraryGranted => photoLibrary == PermissionStatus.granted;
  bool get sensorsGranted => sensors == PermissionStatus.granted;
  bool get locationGranted => location == PermissionStatus.granted;
  bool get locationAlwaysGranted => locationAlways == PermissionStatus.granted;
  bool get locationWhenInUseGranted =>
      locationWhenInUse == PermissionStatus.granted;

  PermissionsState copyWith({
    PermissionStatus? camera,
    PermissionStatus? photoLibrary,
    PermissionStatus? sensors,
    PermissionStatus? location,
    PermissionStatus? locationAlways,
    PermissionStatus? locationWhenInUse,
  }) => PermissionsState(
    camera: camera ?? this.camera,
    photoLibrary: photoLibrary ?? this.photoLibrary,
    sensors: sensors ?? this.sensors,
    location: location ?? this.location,
    locationAlways: locationAlways ?? this.locationAlways,
    locationWhenInUse: locationWhenInUse ?? this.locationWhenInUse,
  );
}
