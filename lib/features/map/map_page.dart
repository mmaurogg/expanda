import 'package:expanda/features/map/user_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPosituinAsync = ref.watch(userLocationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Map Page')),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: currentPosituinAsync.when(
            data: (data) => const _MapView(latitude: 1.0, longitude: 1.0),
            error: (error, stack) => Center(child: Text('Error: $error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

class _MapView extends StatefulWidget {
  final double latitude;
  final double longitude;

  const _MapView({super.key, required this.latitude, required this.longitude});

  @override
  State<_MapView> createState() => __MapViewState();
}

class __MapViewState extends State<_MapView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
