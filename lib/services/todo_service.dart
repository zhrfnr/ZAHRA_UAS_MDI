import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'todos';

  // Create a new todo
  Future<Todo> createTodo(Todo todo) async {
    try {
      DocumentReference docRef = await _firestore.collection(_collection).add(todo.toMap());
      return todo.copyWith(id: docRef.id);
    } catch (e) {
      rethrow;
    }
  }

  // Get all todos for a user
  Stream<List<Todo>> getTodos(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Todo.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  // Update a todo
  Future<void> updateTodo(Todo todo) async {
    try {
      await _firestore.collection(_collection).doc(todo.id).update(todo.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Delete a todo
  Future<void> deleteTodo(String todoId) async {
    try {
      await _firestore.collection(_collection).doc(todoId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Toggle todo completion status
  Future<void> toggleTodoStatus(String todoId, bool isCompleted) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(todoId)
          .update({'isCompleted': isCompleted});
    } catch (e) {
      rethrow;
    }
  }
} 