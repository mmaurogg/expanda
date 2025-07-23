import '../entities/event_model.dart';

abstract class EventsRepository {
  Future<List<EventModel>> getEvents();
  Future<List<EventModel>> getEventsByDate(DateTime date);
  Future<List<EventModel>> getEventsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<EventModel> getEventById(String id);
  Future<EventModel> createEvent(EventModel EventModel);
  Future<EventModel> updateEvent(EventModel EventModel);
  Future<void> deleteEvent(String id);
  Future<EventModel> enrollInEvent(String eventId);
  Future<EventModel> unenrollFromEvent(String eventId);
}
