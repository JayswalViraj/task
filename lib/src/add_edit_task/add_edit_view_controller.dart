// Define the state as a list of tasks
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/global/custom_widgets/custome_loading_indicator_dialog.dart';
import 'package:task/global/utils/extentions.dart';
import 'package:task/global/utils/global_functions.dart';
import '../../global/models/task_model.dart';
import '../../global/services/local_database_service/database_helper.dart';

class AddEditViewControllerState {
  final int? id;
  final String date;
  final String priority;
  final String time;
  final String state;
  final String title;
  final String description;

  AddEditViewControllerState(
      {required this.id,
      required this.date,
      required this.time,
      required this.priority,
      required this.state,
      required this.title,
      required this.description});
  // CopyWith method to easily update the tasks list
  AddEditViewControllerState copyWith(
      {int? id,
      String? date,
      String? time,
      String? priority,
      String? state,
      String? title,
      String? description}) {
    return AddEditViewControllerState(
        id: id ?? this.id,
        priority: priority ?? this.priority,
        date: date ?? this.date,
        time: time ?? this.time,
        state: state ?? this.state,
        title: title ?? this.title,
        description: description ??
            this.description // If no new tasks are passed, keep the old ones
        );
  }
}

class AddEditViewStateNotifier
    extends StateNotifier<AddEditViewControllerState> {
  AddEditViewStateNotifier()
      : super(AddEditViewControllerState(
            priority: '1',
            id: null,
            date: '',
            time: '',
            state: 'New',
            title: '',
            description: ''));

  updateId(int? value) {
    state = state.copyWith(id: value);
  }

  updateTitle(String value) {
    state = state.copyWith(title: value);
  }

  updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  updateState(String value) {
    state = state.copyWith(state: value);
  }

  updatePriority(String value) {
    state = state.copyWith(priority: value);
  }

  updateDate(String value) {
    state = state.copyWith(date: value);
  }

  updateTime(String value) {
    state = state.copyWith(time: value);
  }

  Future<String> pickDate(context) async {
    String date =
        await GloablFuctions().pickDate(context, state.date.toDateTime()) ?? "";
    state = state.copyWith(date: date);
    return date;
  }

  Future<String> pickTime(context) async {
    String time =
        await GloablFuctions().pickTime(context, state.time.toTimeOfDay()) ??
            "";
    state = state.copyWith(time: time);
    return time;
  }

  void addEditeTask(Task task) async {
    if (task.id == null) {
      await DatabaseHelper.insertTask(task.toMap());
    } else {
      await DatabaseHelper.updateTask(
          id: task.id!,
          date: task.date,
          priority: task.priority,
          state: task.state,
          title: task.title,
          description: task.description,
          time: task.time);
    }
  }
}

// Define the provider to access the TasksStateNotifier
final addEditViewProvider =
    StateNotifierProvider<AddEditViewStateNotifier, AddEditViewControllerState>(
  (ref) => AddEditViewStateNotifier(),
);
