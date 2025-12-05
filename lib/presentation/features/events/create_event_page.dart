import 'package:expanda/presentation/features/events/event_form.dart';
import 'package:flutter/material.dart';

class CreateEventPage extends StatelessWidget {
  static const String routeName = '/create-event';
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Evento'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const EventForm(),
    );
  }
}
