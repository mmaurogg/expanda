import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expanda/features/permission/permissions_provider.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: PermissionView(),
    );
  }
}

class PermissionView extends ConsumerWidget {
  PermissionView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final permissions = ref.watch(permissionsProvider);

    return ListView(
      children: [
        CheckboxListTile(
          value: permissions.cameraGranted,
          title: const Text('Camera'),
          subtitle: Text('${permissions.camera}'),
          onChanged: (_) {
            ref.read(permissionsProvider.notifier).requestCameraPermission();
          },
        ),
        CheckboxListTile(
          value: permissions.photoLibraryGranted,
          title: const Text('Photo Library'),
          subtitle: Text('${permissions.photoLibrary}'),
          onChanged: (_) {
            ref
                .read(permissionsProvider.notifier)
                .requestPhotoLibraryPermission();
          },
        ),
        CheckboxListTile(
          value: permissions.sensorsGranted,
          title: const Text('Sensors'),
          subtitle: Text('${permissions.sensors}'),
          onChanged: (_) {
            ref.read(permissionsProvider.notifier).requestSensorsPermission();
          },
        ),
        CheckboxListTile(
          value: permissions.locationGranted,
          title: const Text('Location'),
          subtitle: Text('${permissions.location}'),
          onChanged: (_) {
            ref.read(permissionsProvider.notifier).requestLocationPermission();
          },
        ),
        CheckboxListTile(
          value: permissions.locationAlwaysGranted,
          title: const Text('Location Always'),
          subtitle: Text('${permissions.locationAlways}'),
          onChanged: (_) {
            ref
                .read(permissionsProvider.notifier)
                .requestLocationAlwaysPermission();
          },
        ),
        CheckboxListTile(
          value: permissions.locationWhenInUseGranted,
          title: const Text('Location When In Use'),
          subtitle: Text('${permissions.locationWhenInUse}'),
          onChanged: (_) {
            ref
                .read(permissionsProvider.notifier)
                .requestLocationWhenInUsePermission();
          },
        ),
      ],
    );
  }
}
