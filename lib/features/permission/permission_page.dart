import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  const PermissionView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return ListView(
      children: [
        /* CheckboxListTile(
          value: permissions.cameraGranted,
          title: const Text('Camera'),
          subtitle: Text('${permissions.camera}'),
          onChanged: (_) {},
        ),
        CheckboxListTile(
          value: permissions.photoLibraryGranted,
          title: const Text('Photo Library'),
          subtitle: Text('${permissions.photoLibrary}'),
          onChanged: (_) {},
        ),
        CheckboxListTile(
          value: permissions.sensorsGranted,
          title: const Text('Sensors'),
          subtitle: Text('${permissions.sensors}'),
          onChanged: (_) {},
        ),
        CheckboxListTile(
          value: permissions.locationGranted,
          title: const Text('Location'),
          subtitle: Text('${permissions.location}'),
          onChanged: (_) {},
        ),
        CheckboxListTile(
          value: permissions.locationAlwaysGranted,
          title: const Text('Location Always'),
          subtitle: Text('${permissions.locationAlways}'),
          onChanged: (_) {},
        ),
        CheckboxListTile(
          value: permissions.locationWhenInUseGranted,
          title: const Text('Location When In Use'),
          subtitle: Text('${permissions.locationWhenInUse}'),
          onChanged: (_) {},
        ), */
      ],
    );
  }
}
