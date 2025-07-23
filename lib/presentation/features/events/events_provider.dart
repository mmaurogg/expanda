import 'package:expanda/domain/entities/event_model.dart';
import 'package:expanda/domain/usescases/events_use_case.dart';
import 'package:expanda/presentation/features/events/events_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider principal de eventos
final eventsProvider = StateNotifierProvider<EventsNotifier, EventsState>((
  ref,
) {
  final eventsUseCase = ref.read(eventUseCaseProvider);
  return EventsNotifier(eventsUseCase);
});

class EventsNotifier extends StateNotifier<EventsState> {
  final EventsUseCase _eventsUseCase;

  EventsNotifier(this._eventsUseCase) : super(EventsState.initial());

  Future<void> loadEvents() async {
    state = EventsState.loading();
    try {
      final events = await _eventsUseCase.getEvents();
      state = EventsState.loaded(events);
    } catch (e) {
      state = EventsState.error(e.toString());
    }
  }

  Future<void> loadEventsByDate(DateTime date) async {
    state = state.copyWith(isLoading: true, selectedDate: date);
    try {
      final events = await _eventsUseCase.getEventsByDate(date);
      state = state.copyWith(isLoading: false, events: events, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadEventsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    state = EventsState.loading();
    try {
      final events = await _eventsUseCase.getEventsByDateRange(
        startDate,
        endDate,
      );
      state = EventsState.loaded(events);
    } catch (e) {
      state = EventsState.error(e.toString());
    }
  }

  Future<void> createEvent(EventModel eventModel) async {
    state = state.copyWith(isLoading: true);
    try {
      final newEvent = await _eventsUseCase.createEvent(eventModel);
      final updatedEvents = [...state.events, newEvent];
      state = state.copyWith(
        isLoading: false,
        events: updatedEvents,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateEvent(EventModel EventModel) async {
    state = state.copyWith(isLoading: true);
    try {
      final updatedEvent = await _eventsUseCase.updateEvent(EventModel);
      final updatedEvents =
          state.events
              .map((c) => c.id == updatedEvent.id ? updatedEvent : c)
              .toList();

      state = state.copyWith(
        isLoading: false,
        events: updatedEvents,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteClass(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _eventsUseCase.deleteEvent(id);
      final updatedEvents = state.events.where((c) => c.id != id).toList();
      state = state.copyWith(
        isLoading: false,
        events: updatedEvents,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> enrollInEvent(String eventId) async {
    try {
      final updatedEvent = await _eventsUseCase.enrollInEvent(eventId);
      final updatedEvents =
          state.events
              .map((c) => c.id == updatedEvent.id ? updatedEvent : c)
              .toList();

      state = state.copyWith(events: updatedEvents);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> unenrollFromEvent(String eventId) async {
    try {
      final updatedEvent = await _eventsUseCase.unenrollFromEvent(eventId);
      final updatedEvents =
          state.events
              .map((c) => c.id == updatedEvent.id ? updatedEvent : c)
              .toList();

      state = state.copyWith(events: updatedEvents);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void selectEvent(EventModel EventModel) {
    state = state.copyWith(selectedEvent: EventModel);
  }

  void clearSelection() {
    state = state.copyWith(selectedEvent: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
