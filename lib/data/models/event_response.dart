import 'package:expanda/domain/entities/event_model.dart';

class EventResponse extends EventModel {
  const EventResponse({
    required super.id,
    required super.title,
    required super.description,
    required super.scheduledDate,
    required super.instructorId,
    required super.instructorName,
    required super.maxCapacity,
    required super.currentEnrollments,
    required super.price,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      instructorId: json['instructor_id'] as String,
      instructorName: json['instructor_name'] as String,
      maxCapacity: json['max_capacity'] as int,
      currentEnrollments: json['current_enrollments'] as int,
      price: (json['price'] as num).toDouble(),
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduled_date': scheduledDate.toIso8601String(),
      'instructor_id': instructorId,
      'instructor_name': instructorName,
      'max_capacity': maxCapacity,
      'current_enrollments': currentEnrollments,
      'price': price,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory EventResponse.fromEntity(EventModel entity) {
    return EventResponse(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      scheduledDate: entity.scheduledDate,
      instructorId: entity.instructorId,
      instructorName: entity.instructorName,
      maxCapacity: entity.maxCapacity,
      currentEnrollments: entity.currentEnrollments,
      price: entity.price,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
