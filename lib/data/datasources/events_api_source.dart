import 'package:dio/dio.dart';
import 'package:expanda/data/models/event_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventsRemoteDataSourceProvider = Provider<EventsRemoteDataSource>((ref) {
  final dio = Dio();
  return EventsRemoteDataSourceImpl(dio);
});

abstract class EventsRemoteDataSource {
  Future<List<EventResponse>> getEvents();
  Future<List<EventResponse>> getEventsByDate(DateTime date);
  Future<List<EventResponse>> getEventsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<EventResponse> getEventById(String id);
  Future<EventResponse> createEvent(EventResponse eventResponse);
  Future<EventResponse> updateEvent(EventResponse eventResponse);
  Future<void> deleteEvent(String id);
  Future<EventResponse> enrollInEvent(String eventId);
  Future<EventResponse> unenrollFromEvent(String eventId);
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final Dio _dio;

  EventsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<EventResponse>> getEvents() async {
    try {
      /* final response = await _dio.get('/events');
      final List<dynamic> eventsJson = response.data['data'];
      return eventsJson.map((json) => EventResponse.fromJson(json)).toList(); */
      return [
        EventResponse(
          id: "1",
          title: "Título de la clase 1",
          description: "Descripción de la clase 1",
          scheduledDate: DateTime.now(),
          instructorId: "1",
          instructorName: "Nombre del instructor 1",
          maxCapacity: 30,
          currentEnrollments: 10,
          price: 100,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        EventResponse(
          id: "2",
          title: "Título de la clase 2",
          description: "Descripción de la clase 2",
          scheduledDate: DateTime.now().add(Duration(days: 1)),
          instructorId: "2",
          instructorName: "Nombre del instructor 2",
          maxCapacity: 20,
          currentEnrollments: 5,
          price: 150,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        EventResponse(
          id: "3",
          title: "Título de la clase 3",
          description: "Descripción de la clase 3",
          scheduledDate: DateTime.now().add(Duration(days: 2)),
          instructorId: "3",
          instructorName: "Nombre del instructor 3",
          maxCapacity: 25,
          currentEnrollments: 15,
          price: 200,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        EventResponse(
          id: "4",
          title: "Título de la clase 4",
          description: "Descripción de la clase 4",
          scheduledDate: DateTime.now().add(Duration(days: 3)),
          instructorId: "4",
          instructorName: "Nombre del instructor 4",
          maxCapacity: 30,
          currentEnrollments: 20,
          price: 250,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      throw Exception('Error al obtener eventos: ${e.toString()}');
    }
  }

  @override
  Future<List<EventResponse>> getEventsByDate(DateTime date) async {
    try {
      final response = await _dio.get(
        '/events',
        queryParameters: {'date': date.toIso8601String().split('T')[0]},
      );
      final List<dynamic> eventsJson = response.data['data'];
      return eventsJson.map((json) => EventResponse.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al obtener clases por fecha: ${e.toString()}');
    }
  }

  @override
  Future<List<EventResponse>> getEventsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await _dio.get(
        '/events',
        queryParameters: {
          'start_date': startDate.toIso8601String().split('T')[0],
          'end_date': endDate.toIso8601String().split('T')[0],
        },
      );
      final List<dynamic> eventsJson = response.data['data'];
      return eventsJson.map((json) => EventResponse.fromJson(json)).toList();
    } catch (e) {
      throw Exception(
        'Error al obtener clases por rango de fechas: ${e.toString()}',
      );
    }
  }

  @override
  Future<EventResponse> getEventById(String id) async {
    try {
      final response = await _dio.get('/events/$id');
      return EventResponse.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Error al obtener evento: ${e.toString()}');
    }
  }

  @override
  Future<EventResponse> createEvent(EventResponse eventResponse) async {
    try {
      final response = await _dio.post('/events', data: eventResponse.toJson());
      return EventResponse.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Error al crear evento: ${e.toString()}');
    }
  }

  @override
  Future<EventResponse> updateEvent(EventResponse eventResponse) async {
    try {
      final response = await _dio.put(
        '/events/${eventResponse.id}',
        data: eventResponse.toJson(),
      );
      return EventResponse.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Error al actualizar evento: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteEvent(String id) async {
    try {
      await _dio.delete('/events/$id');
    } catch (e) {
      throw Exception('Error al eliminar evento: ${e.toString()}');
    }
  }

  @override
  Future<EventResponse> enrollInEvent(String eventId) async {
    try {
      final response = await _dio.post('/events/$eventId/enroll');
      return EventResponse.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Error al inscribirse en evento: ${e.toString()}');
    }
  }

  @override
  Future<EventResponse> unenrollFromEvent(String eventId) async {
    try {
      final response = await _dio.delete('/events/$eventId/enroll');
      return EventResponse.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Error al desinscribirse de evento: ${e.toString()}');
    }
  }
}
