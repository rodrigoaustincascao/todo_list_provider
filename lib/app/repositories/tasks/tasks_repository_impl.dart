import 'package:todo_list_provider/app/core/database/sqlite_connection_factory.dart';
import 'package:todo_list_provider/app/repositories/tasks/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  final SqliteConnectionFactory _connectionFactory;

  TasksRepositoryImpl({required SqliteConnectionFactory connectionFactory})
    : _connectionFactory = connectionFactory;

  @override
  Future<void> save(DateTime date, String description) async {
    final conn = await _connectionFactory.openConnection();
    await conn.insert('todo', {
      'id': null,
      'descricao': description,
      'data_hora': date.toIso8601String(),
      'finalizado': 0,
    });
  }
}
