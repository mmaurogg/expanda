import 'package:expanda/features/map/user_location_provider.dart';
import 'package:expanda/features/map/watch_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('location'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LocationView(),
    );
  }
}

class LocationView extends ConsumerWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocationAsync = ref.watch(userLocationProvider);
    final watchLocationAsync = ref.watch(watchLocationProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Ubicacion actual"),

          userLocationAsync.when(
            data: (data) => Text('$data'),
            error: (error, stackTrace) => Text('$error'),
            loading: () => const CircularProgressIndicator(),
          ),

          const Text("Seguimiento usuario"),

          watchLocationAsync.when(
            data: (data) => Text('$data'),
            error: (error, stackTrace) => Text('$error'),
            loading: () => const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
