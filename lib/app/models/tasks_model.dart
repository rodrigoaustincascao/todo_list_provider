class TasksModel {
  final int id;
  final String description;
  final DateTime dateTime;
  final bool finished;

  TasksModel({
    required this.id,
    required this.description,
    required this.dateTime,
    required this.finished,
  });

  factory TasksModel.loadFromDB(Map<String, dynamic> data) {
    return TasksModel(
      id: data['id'],
      description: data['description'],
      dateTime: DateTime.parse(data['dateTime']),
      finished: data['finished'] == 1,
    );
  }
}
