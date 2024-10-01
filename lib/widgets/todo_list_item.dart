import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../class/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.obj,
    required this.onDelete,
  });

  final Todo obj;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        endActionPane:
            ActionPane(motion: ScrollMotion(), extentRatio: 0.25, children: [
          SlidableAction(
            label: 'Deletar',
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete, onPressed: (context){onDelete(obj);},
          )
        ]),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd/MM/yy - HH:mm').format(obj.date),
              ),
              Text(
                obj.title,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
