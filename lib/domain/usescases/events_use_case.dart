import 'package:expanda/data/repositiories/events_repository_imp.dart';
import 'package:expanda/domain/entities/event_model.dart';
import 'package:expanda/domain/repositories/events_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventUseCaseProvider = Provider<EventsUseCase>((ref) {
  final repository = ref.read(eventsRepositoryProvider);
  return EventsUseCase(repository);
});

class EventsUseCase {
  final EventsRepository _repository;

  EventsUseCase(this._repository);

  Future<List<EventModel>> getEvents() async {
    return await _repository.getEvents();
  }

  Future<List<EventModel>> getEventsByDate(DateTime date) async {
    return await _repository.getEventsByDate(date);
  }

  Future<List<EventModel>> getEventsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _repository.getEventsByDateRange(startDate, endDate);
  }

  Future<EventModel> getEventById(String id) async {
    return await _repository.getEventById(id);
  }

  Future<EventModel> createEvent(EventModel event) async {
    return await _repository.createEvent(event);
  }

  Future<EventModel> updateEvent(EventModel event) async {
    return await _repository.updateEvent(event);
  }

  Future<void> deleteEvent(String id) async {
    return await _repository.deleteEvent(id);
  }

  Future<EventModel> enrollInEvent(String eventId) async {
    return await _repository.enrollInEvent(eventId);
  }

  Future<EventModel> unenrollFromEvent(String eventId) async {
    return await _repository.unenrollFromEvent(eventId);
  }

  Stream<List<EventModel>> getEventsStream() {
    return _repository.getEventsStream();
  }
}
