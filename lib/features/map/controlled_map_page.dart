import 'package:flutter/material.dart';

class ControlledMapPage extends StatelessWidget {
  const ControlledMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controlled Map'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(child: Text('Controlled Map View')),
    );
  }
}
