import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_provider/app/core/ui/theme_extensions.dart';

import 'package:todo_list_provider/app/modules/tasks/task_create_controller.dart';

class CalendarButton extends StatelessWidget {
  final dateformat = DateFormat('dd/MM/yyyy');

  CalendarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () async {
        var lastDate = DateTime.now().add(Duration(days: 365));

        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: lastDate,
        );

        context.read<TaskCreateController>().selectedDate = selectedDate;
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.today, color: Colors.grey),
            SizedBox(width: 10),
            Selector<TaskCreateController, DateTime?>(
              selector: (context, controller) => controller.selectedDate,
              builder: (context, selectedDate, child) {
                if (selectedDate != null) {
                  return Text(
                    dateformat.format(selectedDate),
                    style: context.titleStyle,
                  );
                } else {
                  return Text('SELECIONE UMA DATA', style: context.titleStyle);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
