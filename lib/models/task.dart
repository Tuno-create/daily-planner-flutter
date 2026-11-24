class Task {
  String todo;
  DateTime timestamp;
  bool done;

  Task({
    required this.todo,
    required this.timestamp,
    required this.done
  });

  factory Task.fromMap(Map task){
    return Task(
      todo: task['todo'],
      timestamp: task['timestamp'],
      done: task['done'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'todo': todo,
      'timestamp': timestamp,
      'done': done,
    };
  }
}