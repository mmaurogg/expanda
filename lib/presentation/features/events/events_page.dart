import 'package:expanda/presentation/features/events/create_event_page.dart';
import 'package:expanda/presentation/features/events/events_page_state.dart';
import 'package:expanda/presentation/features/events/widgets/class_card.dart';
import 'package:expanda/presentation/features/events/widgets/date_selector.dart';
import 'package:expanda/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'events_provider.dart';

class EventsPage extends ConsumerStatefulWidget {
  static const String routeName = '/events';
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
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
        title: const Text('Eventos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed:
                () => context.push(
                  '${EventsPage.routeName}${CreateEventPage.routeName}',
                ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          /* // Selector de fecha
          const DateSelector(),

          // Lista de clases
          Expanded(child: _buildClassesList(classesState)), */
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              onPressed: () {
                context.push(
                  '${EventsPage.routeName}${CreateEventPage.routeName}',
                );
              },
              text: 'Crear Evento',
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              onPressed: () {
                /* context.push(
                  '${EventsPage.routeName}${CreateEventPage.routeName}',
                ); */
              },
              text: 'Listar clases creadas por mí',
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              onPressed: () {
                /* context.push(
                  '${EventsPage.routeName}${CreateEventPage.routeName}',
                ); */
              },
              text: 'Listar clases inscritas (proximamente)',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassesList(EventsPageState state) {
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
              onPressed:
                  () => context.push(
                    '${EventsPage.routeName}${CreateEventPage.routeName}',
                  ),
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
          final eventModel = state.events[index];
          return ClassCard(
            eventModel: eventModel,
            onTap:
                () => context.push('${EventsPage.routeName}${eventModel.id}'),
          );
        },
      ),
    );
  }
}
