import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_taskNameController.text.isNotEmpty) {
      final task = {
        'name': _taskNameController.text,
        'description': _descriptionController.text.isEmpty ? null : _descriptionController.text,
        'time': _selectedTime,
        'date': _selectedDate,
      };
      Navigator.pop(context, task);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("El nombre de la tarea es obligatorio")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          title: Text("Agregar Tarea")
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(labelText: 'Nombre de la tarea'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción (opcional)'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedTime != null
                    ? _selectedTime!.format(context)
                    : 'Hora no seleccionada'),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                  ),
                  child: Text(
                    'Seleccionar Hora',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_selectedDate != null
                    ? "${_selectedDate!.toLocal()}".split(' ')[0]
                    : 'Fecha no seleccionada'),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                  ),
                  child: Text(
                    'Seleccionar Fecha',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                foregroundColor: Colors.white, // Color del texto en el botón
              ).copyWith(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Theme.of(context).colorScheme.secondary.withOpacity(0.9); // Color cuando está presionado
                    }
                    return Theme.of(context).colorScheme.secondary.withOpacity(0.7); // Color normal
                  },
                ),
              ),
              child: Text(
                'Guardar Tarea',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )

          ],
        ),
      ),
    );
  }
}
