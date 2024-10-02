import 'package:flutter/material.dart';
import 'package:todoolist/repositories/todo_repository.dart';

import '../class/todo.dart';
import '../widgets/todo_list_item.dart';

class ToDooListPage extends StatefulWidget {
  ToDooListPage({super.key});

  @override
  State<ToDooListPage> createState() => _ToDooListPageState();
}

class _ToDooListPageState extends State<ToDooListPage> {
  final TextEditingController todocontroller = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();
  List<Todo> todos = [];
  Todo? deleteTodo;
  int? deleteteTodoPos;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  bool get isFull => todocontroller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: todocontroller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xff1c99de), width: 2),
                          ),
                          labelStyle: TextStyle(color: Color(0xff1c99de))
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      //botao de adicionar tarefas
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff1c99de),
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () {
                        isFull
                            ? setState(() {
                                Todo newtodo = Todo(
                                    title: todocontroller.text,
                                    date: DateTime.now());
                                todos.add(newtodo);
                                todocontroller.clear();
                                todoRepository.saveTodolist(todos);
                              })
                            : null;
                      },
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo obj in todos)
                        TodoListItem(
                          obj: obj,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            'Você possui ${todos.length} tarefas pendentes')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1c99de),
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: ShowDialogDeleteTodo,
                      child: const Text('Limpar tudo',
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo obj) {
    setState(() {
      deleteTodo = obj;
      deleteteTodoPos = todos.indexOf(obj);
      todos.remove(obj);
      todoRepository.saveTodolist(todos);
    });
    ScaffoldMessenger.of(context).clearSnackBars(); // limpa o snackbars
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(
        'Tarefa ${obj.title} foi excluída com sucesso!',
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
          label: 'Reverter',
          textColor: const Color(0xff1c99de),
          onPressed: () {
            setState(() {
              todos.insert(deleteteTodoPos!, deleteTodo!);
            });
          }),
    ));
  }

  void ShowDialogDeleteTodo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text('Você tem certeza de que deseja deletar tudo?'),
        actions: [
          TextButton(
              style: TextButton.styleFrom(foregroundColor: Color(0xff1c99de)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar')),
          TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                deleteLista();
                Navigator.of(context).pop();
              },
              child: const Text('Sim'))
        ],
      ),
    );
  }

  void deleteLista() {
    setState(() {
      todos.clear();
      todoRepository.saveTodolist(todos);
    });
  }
}
