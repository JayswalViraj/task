import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/global/models/task_model.dart';
import 'package:task/global/utils/extentions.dart';

import '../../global/constants/constants.dart';
import '../../global/custom_widgets/custom_snackbar.dart';
import '../../global/custom_widgets/custome_loading_indicator_dialog.dart';
import '../../global/services/local_notification/noti_service.dart';
import '../../global/utils/global_functions.dart';
import '../tasks_page/tasks_view_controller.dart';
import 'add_edit_view_controller.dart';

class AddEditTask extends ConsumerStatefulWidget {
  AddEditTask({super.key, this.arguments});

  Function()? arguments;

  @override
  ConsumerState<AddEditTask> createState() => _AddEditTaskState();
}

class _AddEditTaskState extends ConsumerState<AddEditTask> {
  GlobalKey<FormState> titleFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> descriptionFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> dateFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> timeFormKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  Map<String, dynamic>? arguments;

  void _submitForm() {
    bool isTitleValidate;
    bool isDescriptionValidate;
    bool isDateValidate;
    bool isTimeValidate;
    if (titleFormKey.currentState!.validate()) {
      print("Form Submitted!");
      isTitleValidate = true;
    } else {
      isTitleValidate = false;
    }
    if (descriptionFormKey.currentState!.validate()) {
      print("Form Submitted!");
      isDescriptionValidate = true;
    } else {
      isDescriptionValidate = false;
    }

    if (dateFormKey.currentState!.validate()) {
      print("Form Submitted!");
      isDateValidate = true;
    } else {
      isDateValidate = false;
    }

    if (timeFormKey.currentState!.validate()) {
      print("Form Submitted!");
      isTimeValidate = true;
    } else {
      isTimeValidate = false;
    }

    if (isTitleValidate == true &&
        isDescriptionValidate == true &&
        isDateValidate == true &&
        isTimeValidate == true) {
      ref.read(addEditViewProvider.notifier).addEditeTask(Task(
          id: ref.read(addEditViewProvider).id,
          date: ref.read(addEditViewProvider).date,
          priority: ref.read(addEditViewProvider).priority,
          state: ref.read(addEditViewProvider).state,
          title: ref.read(addEditViewProvider).title,
          description: ref.read(addEditViewProvider).description,
          time: ref.read(addEditViewProvider).time));
      CustomLoadingIndicatorDialog.show(context);
      NotiService().scheduleNotification(
          dateTime: ref.read(addEditViewProvider).date.toDateTime()!.add(
              Duration(
                  hours: ref.read(addEditViewProvider).time.toTimeOfDay()!.hour,
                  minutes: ref
                      .read(addEditViewProvider)
                      .time
                      .toTimeOfDay()!
                      .minute)),
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          title: "🔔 Reminder: It's Time!",
          description:
              "📌 ${ref.read(addEditViewProvider).title} is scheduled for ${ref.read(addEditViewProvider).time.to12HourFormatDayOfTime()}. Stay on track and get things done! ✅");



      Future.delayed(Duration(seconds: 3), () {
        CustomLoadingIndicatorDialog.hide(context);
        CustomSnackbar.showSuccess(context, "Task saved successfully!");
        CustomLoadingIndicatorDialog.hide(context);
        ref.invalidate(tasksProvider);
        ref.read(tasksProvider.notifier).loadAllTask();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      print('Received data: ' + arguments.toString());

      if (arguments != null) {
        Task task = Task.fromMap(arguments!);

        ref.read(addEditViewProvider.notifier).updateId(task.id);

        titleController.text = task.title;
        ref.read(addEditViewProvider.notifier).updateTitle(task.title);

        descriptionController.text = task.description;
        ref
            .read(addEditViewProvider.notifier)
            .updateDescription(task.description);

        ref.read(addEditViewProvider.notifier).updateState(task.state);

        ref.read(addEditViewProvider.notifier).updatePriority(task.priority);

        dateController.text = task.date.toDDMMMYYYY();
        ref.read(addEditViewProvider.notifier).updateDate(task.date);

        timeController.text = task.time.to12HourFormatDayOfTime();
        ref.read(addEditViewProvider.notifier).updateTime(task.time);
      } else {}
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("build method");
    return Scaffold(
      appBar: AppBar(
        // leading: ,
        title: Consumer(builder: (context, ref, child) {
          return Text(
            ref.watch(addEditViewProvider).id == null
                ? "Add Task"
                : "Edit Task",
          );
        }),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Column(
            children: [
              // Title Field
              Form(
                key: titleFormKey,
                child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Title",
                      labelText: "Title",
                    ),
                    onChanged: (value) {
                      titleFormKey.currentState!.validate();
                      ref.read(addEditViewProvider.notifier).updateTitle(value);
                    },
                    validator: (value) =>
                        value!.isEmpty ? "Title is required" : null,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              SizedBox(height: 16),

              // Description Field
              Form(
                key: descriptionFormKey,
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: "Description", hintText: "Description"),
                  onChanged: (value) {
                    descriptionFormKey.currentState!.validate();
                    ref
                        .read(addEditViewProvider.notifier)
                        .updateDescription(value);
                  },
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? "Description is required" : null,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(height: 16),

              // State Dropdown
              Consumer(builder: (context, ref, child) {
                return DropdownButtonFormField<String>(
                    value: ref.watch(addEditViewProvider).state,
                    items: Constants.status
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (value) {
                      ref
                          .read(addEditViewProvider.notifier)
                          .updateState(value!);
                    },
                    decoration:
                        InputDecoration(labelText: "State", hintText: "State"),
                    style: Theme.of(context).textTheme.titleMedium);
              }),
              SizedBox(height: 16),

              // Priority Dropdown
              Consumer(builder: (context, ref, child) {
                return DropdownButtonFormField<String>(
                  value: ref.watch(addEditViewProvider).priority,
                  items: Constants.priorities
                      .map((p) => DropdownMenuItem(value: p, child: Text("$p")))
                      .toList(),
                  onChanged: (value) {
                    ref
                        .read(addEditViewProvider.notifier)
                        .updatePriority(value!);
                  },
                  decoration: InputDecoration(
                    labelText: "Priority",
                    hintText: "Priority",
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                );
              }),
              SizedBox(height: 16),

              // Date TextFormField
              Form(
                key: dateFormKey,
                child: TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Date",
                    hintText: "Date",
                    suffixIcon: Icon(
                      Icons.calendar_today,
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Date is required" : null,
                  onTap: () async {
                    String date = await ref
                        .read(addEditViewProvider.notifier)
                        .pickDate(context);
                    dateController.text = date.toString().toDDMMMYYYY();
                    dateFormKey.currentState!.validate();
                  },
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(height: 16),

              // Time TextFormField
              Form(
                key: timeFormKey,
                child: TextFormField(
                  controller: timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Time",
                    hintText: "Time",
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Time is required" : null,
                  onTap: () async {
                    String time = await ref
                        .read(addEditViewProvider.notifier)
                        .pickTime(context);

                    print("time" + time);
                    timeController.text = time.to12HourFormatDayOfTime();
                    timeFormKey.currentState!.validate();
                  },
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Save Task", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    ref.invalidate(addEditViewProvider); // Reset before dispose
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
}
