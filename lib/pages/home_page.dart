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
  double leftPosition = -1000;

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
      taskNaviAppear();
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
      taskNaviAppear();
    });
    db.upDataDataBase();
  }

  void taskNaviAppear() {
    setState(() {
      leftPosition = 4;
      Future.delayed(const Duration(seconds: 3), () {
        taskNaviDisappear();
      });
    });
  }

  void taskNaviDisappear() {
    setState(() {
      leftPosition = -1000;
    });
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
        elevation: 10.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Stack(
          children: [
            ListView.builder(
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
            Positioned(
              bottom: 8.0,
              left: leftPosition,
              child: Container(
                width: 200.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Your Tasks：${db.toDoList.length}',
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: taskNaviDisappear,
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
