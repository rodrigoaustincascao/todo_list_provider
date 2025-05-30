import 'package:todo_list_provider/app/models/tasks_model.dart';
import 'package:todo_list_provider/app/models/week_task_model.dart';

abstract class TasksService {
  Future<void> save(DateTime date, String description);
  Future<List<TasksModel>> getToday();
  Future<List<TasksModel>> getTomorrow();
  Future<WeekTaskModel> getWeek();
  Future<void> checkOrUncheckTask(TasksModel task);
}
