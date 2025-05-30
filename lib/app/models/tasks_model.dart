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
      description: data['descricao'],
      dateTime: DateTime.parse(data['data_hora']),
      finished: data['finalizado'] == 1,
    );
  }
}
