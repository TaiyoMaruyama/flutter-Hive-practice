import 'package:hive/hive.dart';

class ToDoDataBase {
  List toDoList = [];
  //reference our box
  final _myBox = Hive.box('myBox');

  // このアプリを初めて起動する場合はこのメソッドを実行
  void createInitialData() {
    toDoList = [
      ['このアプリはTODO管理です', false],
      ['ここにあなたのTODOを追加してください', false],
      ['チェックボックスは完了の印です', true],
      ['右端からスライドすると削除ボタンが出てきます', true],
    ];
  }

  //load the data from database
  void loadData() {
    // this 'TODOLIST' is the something like key
    toDoList = _myBox.get('TODOLIST');
  }

  //up data the database
  void upDataDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
