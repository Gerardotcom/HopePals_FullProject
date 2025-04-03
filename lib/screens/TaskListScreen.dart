import 'package:flutter/material.dart';
import 'package:hopepals_game/Page/AddTaskScreen.dart';
import 'package:hopepals_game/Page/ButtomNavBar.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Map<String, dynamic>> tasks = [];

  void _navigateToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );
    if (result != null) {
      setState(() {
        tasks.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x24000000),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        title: Text('Lista de pendientes'),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: kBottomNavigationBarHeight, // Espacio para la barra de navegación
        ),
        child: Center(
          child: tasks.isEmpty
              ? Text("No hay ningún recordatorio por el momento")
              : ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['name'],
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      task['description'] ?? 'Sin descripción',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      task['date'] != null || task['time'] != null
                          ? "Fecha y hora: ${task['date'] != null ? task['date'].toLocal().toString().split(' ')[0] : ''} ${task['time'] != null ? task['time'].format(context) : ''}"
                          : "Sin fecha límite",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 10), // Margen inferior
        child: FloatingActionButton(
          onPressed: _navigateToAddTask,
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}