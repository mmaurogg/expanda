import 'package:expanda/domain/entities/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassCard extends StatelessWidget {
  final EventModel eventModel;
  final VoidCallback? onTap;

  const ClassCard({super.key, required this.eventModel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y estado
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventModel.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Por ${eventModel.instructorName}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),

              const SizedBox(height: 12),

              // Descripción
              Text(
                eventModel.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Información de fecha y hora
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat(
                      'dd/MM/yyyy HH:mm',
                    ).format(eventModel.scheduledDate),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Información de cupos
              Row(
                children: [
                  Icon(Icons.people, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${eventModel.currentEnrollments}/${eventModel.maxCapacity} inscritos',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  const Spacer(),
                  Text(
                    '\$${eventModel.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Barra de progreso de cupos
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: eventModel.currentEnrollments / eventModel.maxCapacity,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  eventModel.isFull
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String text;

    if (!eventModel.isActive) {
      backgroundColor = Colors.grey[300]!;
      textColor = Colors.grey[700]!;
      text = 'Inactiva';
    } else if (eventModel.isFull) {
      backgroundColor = Colors.red[100]!;
      textColor = Colors.red[700]!;
      text = 'Llena';
    } else if (eventModel.scheduledDate.isBefore(DateTime.now())) {
      backgroundColor = Colors.orange[100]!;
      textColor = Colors.orange[700]!;
      text = 'Finalizada';
    } else {
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[700]!;
      text = 'Disponible';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
