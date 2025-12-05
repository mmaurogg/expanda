import 'package:expanda/domain/entities/event_model.dart';
import 'package:expanda/presentation/features/auth/auth_provider.dart';
import 'package:expanda/presentation/features/events/events_provider.dart';
import 'package:expanda/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventForm extends ConsumerStatefulWidget {
  final EventModel? event;
  const EventForm({super.key, this.event});

  @override
  ConsumerState<EventForm> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends ConsumerState<EventForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructorNameController = TextEditingController();
  final _maxCapacityController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isActive = true;

  @override
  void initState() {
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _instructorNameController.text = widget.event!.instructorName;
      _maxCapacityController.text = widget.event!.maxCapacity.toString();
      _priceController.text = widget.event!.price.toString();
      //_selectedDate = widget.event!.date;
      //_selectedTime = TimeOfDay.fromDateTime(widget.event!.date);
      _isActive = widget.event!.isActive;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _instructorNameController.dispose();
    _maxCapacityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsState = ref.watch(eventsProvider);

    ref.listen(eventsProvider, (previous, next) {
      if (previous?.isLoading == true &&
          next.isLoading == false &&
          next.error == null) {
        // Evento creado exitosamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Evento creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de título
            CustomTextFormField(
              controller: _titleController,
              label: 'Título del evento',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un título';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Campo de descripción
            CustomTextFormField(
              controller: _descriptionController,
              label: 'Descripción',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una descripción';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Campo de instructor
            CustomTextFormField(
              controller: _instructorNameController,
              label: 'Nombre del instructor',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa el nombre del instructor';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Selector de fecha
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Text(
                      'Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Selector de hora
            GestureDetector(
              onTap: _selectTime,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 12),
                    Text(
                      'Hora: ${_selectedTime.format(context)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Row con capacidad y precio
            Row(
              children: [
                // Campo de capacidad máxima
                Expanded(
                  child: CustomTextFormField(
                    controller: _maxCapacityController,
                    label: 'Capacidad máxima',
                    prefixIcon: Icon(Icons.people),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa la capacidad';
                      }
                      final capacity = int.tryParse(value);
                      if (capacity == null || capacity <= 0) {
                        return 'Capacidad inválida';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(width: 16),

                // Campo de precio
                Expanded(
                  child: CustomTextFormField(
                    controller: _priceController,
                    label: 'Precio',
                    prefixIcon: Icon(Icons.attach_money),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa el precio';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price < 0) {
                        return 'Precio inválido';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Switch de activo
            SwitchListTile(
              title:
                  _isActive
                      ? const Text('Evento activo')
                      : const Text('Evento inactivo'),
              subtitle: Text(
                _isActive
                    ? 'El evento estará disponible para inscripciones'
                    : 'El evento no estará disponible',
              ),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // Mostrar error si existe
            if (eventsState.error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        eventsState.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Botón de crear
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: eventsState.isLoading ? null : _createEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child:
                    eventsState.isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : const Text(
                          'Crear Evento',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _createEvent() {
    final userState = ref.watch(authProvider);

    if (_formKey.currentState!.validate()) {
      // Combinar fecha y hora
      final scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final eventEntity = EventModel(
        //id: '', // Se genera en el backend
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        scheduledDate: scheduledDateTime,
        instructorId: userState.user?.id ?? '',
        instructorName: _instructorNameController.text.trim(),
        maxCapacity: int.parse(_maxCapacityController.text),
        currentEnrollments: 0,
        price: double.parse(_priceController.text),
        isActive: _isActive,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      ref.read(eventsProvider.notifier).createEvent(eventEntity);

      //TODO: falta implementar cuando es update
    }
  }
}
