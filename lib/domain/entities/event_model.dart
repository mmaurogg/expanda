class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime scheduledDate;
  final String instructorId;
  final String instructorName;
  final int maxCapacity;
  final int currentEnrollments;
  final double price;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledDate,
    required this.instructorId,
    required this.instructorName,
    required this.maxCapacity,
    required this.currentEnrollments,
    required this.price,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get hasAvailableSpots => currentEnrollments < maxCapacity;
  bool get isFull => currentEnrollments >= maxCapacity;
  int get availableSpots => maxCapacity - currentEnrollments;

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? scheduledDate,
    String? instructorId,
    String? instructorName,
    int? maxCapacity,
    int? currentEnrollments,
    double? price,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      currentEnrollments: currentEnrollments ?? this.currentEnrollments,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
