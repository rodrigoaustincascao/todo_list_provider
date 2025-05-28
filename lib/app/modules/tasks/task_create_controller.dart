import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/services/tasks/tasks_service.dart';

class TaskCreateController extends DefaultChangeNotifier {
  final TasksService _tasksService;

  DateTime? _selectedDate;

  TaskCreateController({required TasksService tasksService})
    : _tasksService = tasksService;

  set selectedDate(DateTime? value) {
    resetState();
    _selectedDate = value;
    notifyListeners();
  }

  DateTime? get selectedDate => _selectedDate;

  Future<void> save(String description) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      if (_selectedDate != null) {
        await _tasksService.save(_selectedDate!, description);
        success();
      } else {
        setError('Data da task não selecionada');
      }
    } on Exception catch (e) {
      setError('Erro ao cadastrar task');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
