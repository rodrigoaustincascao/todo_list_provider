import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';
import 'package:todo_list_provider/app/models/task_filter_enum.dart';
import 'package:todo_list_provider/app/models/total_tasks_model.dart';
import 'package:todo_list_provider/app/modules/home/home_controller.dart';

class TodoCardFilter extends StatelessWidget {
  final String label;
  final TaskFilterEnum taskFilterEnum;
  final TotalTasksModel? totalTasksModel;
  final bool selected;

  const TodoCardFilter({
    super.key,
    required this.label,
    required this.taskFilterEnum,
    this.totalTasksModel,
    required this.selected,
  });

  double _getPercentFinish() {
    final total = totalTasksModel?.totalTasks ?? 0.0;
    final totalFinish = totalTasksModel?.totalTasksFinish ?? 0.1;

    if (total == 0) {
      return 0;
    }

    return ((totalFinish * 100) / total) / 100;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          () =>
              context.read<HomeController>().findTasks(filter: taskFilterEnum),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        constraints: BoxConstraints(minHeight: 120, maxWidth: 150),
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? context.primaryColor : Colors.white,
          border: Border.all(
            width: 1,
            color: Colors.grey.shade500.withAlpha((0.8 * 255).round()),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${totalTasksModel?.totalTasks ?? 0} Tasks',
              style: context.titleStyle.copyWith(
                fontSize: 10,
                color: selected ? Colors.white : Colors.grey.shade500,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: _getPercentFinish()),
              duration: Duration(seconds: 1),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  backgroundColor:
                      selected
                          ? context.primaryColorLight
                          : Colors.grey.shade500,
                  value: value,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    selected ? Colors.white : context.primaryColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
