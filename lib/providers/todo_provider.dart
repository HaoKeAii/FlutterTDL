import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Todo> get todos => _todos;

  TodoProvider() {
    fetchTodos();
  }

  //Fetch Firestore list
  Future<void> fetchTodos() async {
  _firestore.collection('todos').snapshots().listen((snapshot) {
    _todos.clear();
    for (var doc in snapshot.docs) {
      _todos.add(
        Todo(
          id: doc.id, //documentId
          title: doc['title'],
          isCompleted: doc['isCompleted'],
        ),
      );
    }
    notifyListeners();
  });
}

  //AddTask
  Future<void> addTodo(String title) async {
    await _firestore.collection('todos').add({
      'title': title,
      'isCompleted': false,
    });
  }

  Future<void> toggleTodoStatus(int index) async {
    final docId = _todos[index].id; 
    final doc = _firestore.collection('todos').doc(docId);
    await doc.update({'isCompleted': !_todos[index].isCompleted});
  }

  //DeleteTask
  Future<void> removeTodo(int index) async {
    final docId = _todos[index].id; // Get documentId
    await _firestore.collection('todos').doc(docId).delete();
  }
}
