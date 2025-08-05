import 'package:expanda/presentation/features/events/events_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DateSelector extends ConsumerStatefulWidget {
  const DateSelector({super.key});

  @override
  ConsumerState<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends ConsumerState<DateSelector> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Selector de fecha principal
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('dd/MM/yyyy').format(_selectedDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(eventsProvider.notifier)
                      .loadEventsByDate(_selectedDate);
                },
                child: const Text('Filtrar'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Accesos rápidos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickDateButton('Hoy', DateTime.now()),
              _buildQuickDateButton(
                'Mañana',
                DateTime.now().add(const Duration(days: 1)),
              ),
              _buildQuickDateButton(
                'Esta semana',
                null, // null indica que es rango semanal
                isWeekRange: true,
              ),
              TextButton(
                onPressed: () {
                  ref.read(eventsProvider.notifier).loadEvents();
                },
                child: const Text('Todas'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDateButton(
    String label,
    DateTime? date, {
    bool isWeekRange = false,
  }) {
    return TextButton(
      onPressed: () {
        if (isWeekRange) {
          final now = DateTime.now();
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          ref
              .read(eventsProvider.notifier)
              .loadEventsByDateRange(startOfWeek, endOfWeek);
        } else if (date != null) {
          setState(() {
            _selectedDate = date;
          });
          ref.read(eventsProvider.notifier).loadEventsByDate(date);
        }
      },
      child: Text(label),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      ref.read(eventsProvider.notifier).loadEventsByDate(picked);
    }
  }
}
