import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTitle extends StatelessWidget {
  final String taskName;
  final bool taskComplete;
  late Function(bool?)? onChange;
  late Function(BuildContext) handleDelete;

  ToDoTitle(
      {required this.taskName,
      required this.taskComplete,
      required this.onChange,
      required this.handleDelete,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),

      ///　初めてみたゾーン
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: handleDelete,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(8.0),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(25.0),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskComplete,
                onChanged: onChange,
                activeColor: Colors.black,
              ),
              Expanded(
                child: Text(
                  taskName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    decoration: taskComplete
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
