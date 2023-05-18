import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app_tutorial/database/database.dart';
import 'package:todo_app_tutorial/util/todo_title.dart';

import '../util/dialog_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the Hive box
  final _myBox = Hive.box('myBox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is first time ever opening this app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.upDataDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
    });
    Navigator.of(context).pop();
    _controller.text = '';
    db.upDataDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.upDataDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade300,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'To Do',
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 60.0,
            child: Center(
              child: Text(
                'Your Todo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (BuildContext context, int index) {
                return ToDoTitle(
                  taskName: db.toDoList[index][0],
                  taskComplete: db.toDoList[index][1],
                  onChange: (value) => checkBoxChanged(value, index),
                  handleDelete: (context) => deleteTask(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
