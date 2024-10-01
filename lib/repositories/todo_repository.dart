import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../class/todo.dart';

const todolistKey = 'todo_list';

class TodoRepository {
  TodoRepository() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }

  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todolistKey) ?? '[]';
    final List jsonDecode = json.decode(jsonString) as List;
    return jsonDecode.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodolist(List<Todo> todos) {
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(todolistKey, jsonString);
  }
}