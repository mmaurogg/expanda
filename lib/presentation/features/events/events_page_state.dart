import 'package:expanda/domain/entities/event_model.dart';

class EventsPageState {
  final bool isLoading;
  final List<EventModel> events;
  final String? error;
  final DateTime? selectedDate;
  final EventModel? selectedEvent;

  const EventsPageState._({
    this.isLoading = false,
    this.events = const [],
    this.error,
    this.selectedDate,
    this.selectedEvent,
  });

  factory EventsPageState.initial() => const EventsPageState._();

  factory EventsPageState.loading() => const EventsPageState._(isLoading: true);

  factory EventsPageState.loaded(List<EventModel> events) =>
      EventsPageState._(events: events);

  factory EventsPageState.error(String error) =>
      EventsPageState._(error: error);

  EventsPageState copyWith({
    bool? isLoading,
    List<EventModel>? events,
    String? error,
    DateTime? selectedDate,
    EventModel? selectedEvent,
  }) {
    return EventsPageState._(
      isLoading: isLoading ?? this.isLoading,
      events: events ?? this.events,
      error: error ?? this.error,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedEvent: selectedEvent ?? this.selectedEvent,
    );
  }
}
