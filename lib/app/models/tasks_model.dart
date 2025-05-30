// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  TasksModel copyWith({
    int? id,
    String? description,
    DateTime? dateTime,
    bool? finished,
  }) {
    return TasksModel(
      id: id ?? this.id,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      finished: finished ?? this.finished,
    );
  }
}
