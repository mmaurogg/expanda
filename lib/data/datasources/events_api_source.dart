import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expanda/data/datasources/api_source_firestore.dart';
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

class EventsRemoteDataSourceImpl extends ApiSourceFirestore
    implements EventsRemoteDataSource {
  EventsRemoteDataSourceImpl(super.firestore);

  @override
  Future<List<EventResponse>> getEvents() async {
    try {
      final querySnapshot = await getFirestore<EventResponse>(
        collection: 'events',
      );

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Add the document ID to the data
        return EventResponse.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener eventos: ${e.toString()}');
    }
  }

  @override
  Future<List<EventResponse>> getEventsByDate(DateTime date) async {
    throw UnimplementedError();
  }

  @override
  Future<List<EventResponse>> getEventsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<EventResponse> getEventById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<EventResponse> createEvent(EventResponse event) async {
    try {
      final eventData = event.toJson();

      final docRef = await addFirestore(collection: 'events', json: eventData);

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
    throw UnimplementedError();
  }

  @override
  Future<void> deleteEvent(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<EventResponse> enrollInEvent(String eventId) async {
    throw UnimplementedError();
  }

  @override
  Future<EventResponse> unenrollFromEvent(String eventId) async {
    throw UnimplementedError();
  }

  @override
  Stream<List<EventResponse>> getEventsStream() {
    throw UnimplementedError();
  }
}
