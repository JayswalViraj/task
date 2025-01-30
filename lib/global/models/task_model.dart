class Task {
  int? id;
  String date;
  String priority;
  String state;
  String title;
  String description;
  String time;

  Task(
      {this.id,
      required this.date,
      required this.priority,
      required this.state,
      required this.title,
      required this.description,
      required this.time});

  // Convert a Task object to a Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'priority': priority,
      'state': state,
      'title': title,
      'description': description,
      'time': time
    };
  }

  // Convert a Map (JSON) to a Task object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'],
        date: map['date'],
        priority: map['priority'],
        state: map['state'],
        title: map['title'],
        description: map['description'],
        time: map['time']);
  }
}
