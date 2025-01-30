import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task/global/utils/extentions.dart';

import '../../global/custom_widgets/custom_task_card.dart';
import '../../global/models/task_model.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task? task;

  TaskDetailsPage({required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.task == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.do_not_disturb_alt_sharp,
                      size: 30,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "No Data Found",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title
                    Text("Title: " + widget.task!.title,
                        style: Theme.of(context).textTheme.titleSmall),
                    SizedBox(height: 12),
                    Divider(color: Colors.grey[300], thickness: 1),
                    
                    // Task Description
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text("Description: " + widget.task!.description,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    Divider(color: Colors.grey[300], thickness: 1),
                    SizedBox(height: 10),
                    
                    // Task Information (State, Priority, Date, Time)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TaskDetailRow(
                          label1: 'State',
                          value1: widget.task!.state,
                          label2: 'Date',
                          value2: widget.task!.date.toDDMMMYYYY(),
                        ),
                        SizedBox(height: 16),
                        TaskDetailRow(
                          label1: 'Priority',
                          value1: widget.task!.priority,
                          label2: 'Time',
                          value2: widget.task!.time.to12HourFormatDayOfTime(),
                        ),
                      ],
                    ),
                  ],
                ),
            ),
      ),
    );
  }
}

class TaskDetailRow extends StatelessWidget {
  final String label1;
  final String value1;
  final String label2;
  final String value2;

  TaskDetailRow({
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TaskDetailColumn(label: label1, value: value1),
        SizedBox(
          height: 10,
        ),
        _TaskDetailColumn(label: label2, value: value2),
      ],
    );
  }
}

class _TaskDetailColumn extends StatelessWidget {
  final String label;
  final String value;

  _TaskDetailColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: getStatusColor(value).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: getStatusColor(value),
            ),
          ),
        ),
      ],
    );
  }
}
