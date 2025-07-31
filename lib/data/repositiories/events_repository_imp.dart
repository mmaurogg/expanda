import 'package:expanda/data/datasources/events_api_source.dart';
import 'package:expanda/data/models/event_response.dart';
import 'package:expanda/domain/entities/event_model.dart';
import 'package:expanda/domain/repositories/events_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  final remoteDataSource = ref.read(eventsRemoteDataSourceProvider);
  return EventsRepositoryImpl(remoteDataSource);
});

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource _remoteDataSource;

  EventsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<EventModel>> getEvents() async {
    return await _remoteDataSource.getEvents();
  }

  @override
  Future<List<EventModel>> getEventsByDate(DateTime date) async {
    return await _remoteDataSource.getEventsByDate(date);
  }

  @override
  Future<List<EventModel>> getEventsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _remoteDataSource.getEventsByDateRange(startDate, endDate);
  }

  @override
  Future<EventModel> getEventById(String id) async {
    return await _remoteDataSource.getEventById(id);
  }

  @override
  Future<EventModel> createEvent(EventModel eventEntity) async {
    final eventRes = EventResponse.fromEntity(eventEntity);
    return await _remoteDataSource.createEvent(eventRes);
  }

  @override
  Future<EventModel> updateEvent(EventModel eventEntity) async {
    final eventRes = EventResponse.fromEntity(eventEntity);
    return await _remoteDataSource.updateEvent(eventRes);
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _remoteDataSource.deleteEvent(id);
  }

  @override
  Future<EventModel> enrollInEvent(String eventId) async {
    return await _remoteDataSource.enrollInEvent(eventId);
  }

  @override
  Future<EventModel> unenrollFromEvent(String eventId) async {
    return await _remoteDataSource.unenrollFromEvent(eventId);
  }

  @override
  Stream<List<EventModel>> getEventsStream() {
    return _remoteDataSource.getEventsStream();
  }
}
