import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:expanda/data/models/event_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventsRemoteDataSourceProvider = Provider<EventsRemoteDataSource>((ref) {
  final firestore = FirebaseFirestore.instance;
  return EventsRemoteDataSourceImpl(firestore);
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
  Stream<List<EventResponse>> getEventsStream();
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final FirebaseFirestore _firestore;

  final Dio _dio = Dio();

  EventsRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<EventResponse>> getEvents() async {
    try {
      final querySnapshot =
          await _firestore
              .collection('events')
              //.where('isActive', isEqualTo: true)
              //.orderBy('scheduledDate')
              .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add the document ID to the data
        return EventResponse.fromJson(data);
      }).toList();
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
  Future<EventResponse> createEvent(EventResponse event) async {
    try {
      final eventData = event.toJson();

      final docRef = await _firestore.collection('events').add(eventData);
      final createdDoc = await docRef.get();
      final data = createdDoc.data() as Map<String, dynamic>;
      data['id'] = createdDoc.id; // Add the document ID to the data
      return EventResponse.fromJson(data);
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

  @override
  Stream<List<EventResponse>> getEventsStream() {
    return _firestore
        .collection('events')
        .where('isActive', isEqualTo: true)
        .orderBy('scheduledDate')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => EventResponse.fromJson(doc.data()))
                  .toList(),
        );
  }
}
