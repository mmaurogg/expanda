import 'package:expanda/domain/entities/event_model.dart';

class EventsState {
  final bool isLoading;
  final List<EventModel> events;
  final String? error;
  final DateTime? selectedDate;
  final EventModel? selectedEvent;

  const EventsState._({
    this.isLoading = false,
    this.events = const [],
    this.error,
    this.selectedDate,
    this.selectedEvent,
  });

  factory EventsState.initial() => const EventsState._();

  factory EventsState.loading() => const EventsState._(isLoading: true);

  factory EventsState.loaded(List<EventModel> events) =>
      EventsState._(events: events);

  factory EventsState.error(String error) => EventsState._(error: error);

  EventsState copyWith({
    bool? isLoading,
    List<EventModel>? events,
    String? error,
    DateTime? selectedDate,
    EventModel? selectedEvent,
  }) {
    return EventsState._(
      isLoading: isLoading ?? this.isLoading,
      events: events ?? this.events,
      error: error ?? this.error,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedEvent: selectedEvent ?? this.selectedEvent,
    );
  }
}
