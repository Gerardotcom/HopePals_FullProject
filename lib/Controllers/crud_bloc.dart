import 'package:flutter_bloc/flutter_bloc.dart';

// Eventos del Bloc
abstract class CrudEvent {}

class FetchTodos extends CrudEvent {}

class AddTodo extends CrudEvent {
  final String title;
  AddTodo({required this.title});
}

class DeleteTodo extends CrudEvent {
  final int id;
  DeleteTodo({required this.id});
}

class FetchSpecificTodo extends CrudEvent {
  final int id;
  FetchSpecificTodo({required this.id});
}

// Estados del Bloc
abstract class CrudState {}

class CrudInitial extends CrudState {}

class DisplayTodos extends CrudState {
  final List<Todo> todo;
  DisplayTodos({required this.todo});
}

// Modelo de Tarea (Todo)
class Todo {
  final int? id;
  final String title;

  Todo({this.id, required this.title});
}

// Bloc de CRUD
class CrudBloc extends Bloc<CrudEvent, CrudState> {
  List<Todo> _todos = [];

  CrudBloc() : super(CrudInitial()) {
    on<FetchTodos>((event, emit) {
      emit(DisplayTodos(todo: _todos));
    });

    on<AddTodo>((event, emit) {
      _todos.add(Todo(
        id: _todos.length + 1,
        title: event.title,
      ));
      emit(DisplayTodos(todo: _todos));
    });

    on<DeleteTodo>((event, emit) {
      _todos.removeWhere((todo) => todo.id == event.id);
      emit(DisplayTodos(todo: _todos));
    });

    on<FetchSpecificTodo>((event, emit) {
      final todo = _todos.firstWhere((todo) => todo.id == event.id);
      // Aquí puedes manejar la lógica para mostrar detalles del TODO seleccionado
    });
  }
}
