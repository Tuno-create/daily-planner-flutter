import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _newTaskContent;
  Box? _box;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Planner'),
        centerTitle: true,
      ),
      body: _tasksView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayTaskPopup,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _tasksView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _box = snapshot.data;
          return _tasksList();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _tasksList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        var task = Task.fromMap(tasks[index]);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(
              task.todo,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                decoration: task.done ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              '${task.timestamp.day}/${task.timestamp.month}/${task.timestamp.year}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  task.done
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank,
                  color: Colors.red,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () {
                    _box!.deleteAt(index);
                    setState(() {});
                  },
                ),
              ],
            ),
            onTap: () {
              task.done = !task.done;
              _box!.putAt(index, task.toMap());
              setState(() {});
            },
            onLongPress: () {
              _box!.deleteAt(index);
              setState(() {});
            },
          ),
        );
      },
    );
  }

  void _displayTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a ToDo'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter task...',
            ),
            onChanged: (value) {
              setState(() {
                _newTaskContent = value;
              });
            },
            onSubmitted: (_) {
              if (_newTaskContent != null && _newTaskContent!.trim().isNotEmpty) {
                var task = Task(
                  todo: _newTaskContent!,
                  timestamp: DateTime.now(),
                  done: false,
                );
                _box!.add(task.toMap());
                setState(() {
                  _newTaskContent = null;
                  Navigator.pop(context);
                });
              }
            },
          ),
        );
      },
    );
  }
}