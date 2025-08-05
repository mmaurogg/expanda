import 'package:expanda/presentation/features/events/events_state.dart';
import 'package:expanda/presentation/features/events/widgets/class_card.dart';
import 'package:expanda/presentation/features/events/widgets/date_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'events_provider.dart';

class ClassesPage extends ConsumerStatefulWidget {
  const ClassesPage({super.key});

  @override
  ConsumerState<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends ConsumerState<ClassesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventsProvider.notifier).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final classesState = ref.watch(eventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clases'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => context.push('/events/create'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          // Selector de fecha
          const DateSelector(),

          // Lista de clases
          Expanded(child: _buildClassesList(classesState)),
        ],
      ),
    );
  }

  Widget _buildClassesList(EventsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Error al cargar las clases',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(eventsProvider.notifier).loadEvents();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state.events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay clases programadas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Programa tu primera clase',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.push('/classes/create'),
              icon: const Icon(Icons.add),
              label: const Text('Crear Clase'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(eventsProvider.notifier).loadEvents(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.events.length,
        itemBuilder: (context, index) {
          final EventModel = state.events[index];
          return ClassCard(
            eventModel: EventModel,
            onTap: () => context.push('/classes/${EventModel.id}'),
          );
        },
      ),
    );
  }
}
