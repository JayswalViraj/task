import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task/global/constants/constants.dart';

import '../../global/models/task_model.dart';
import '../../global/services/local_database_service/database_helper.dart';

// Define the state as a list of tasks
class TasksState {
  final List<Task> tasks;
  final List<String> statuses = ["Status All", ...Constants.status];
  final String selectedStatus;
  final List<String> priorities = ["Priority All", ...Constants.priorities];
  final String selectedPrioriti;
  final Task? selectedTask;

  TasksState(
      {required this.tasks,
      required this.selectedStatus,
      required this.selectedPrioriti,required this.selectedTask});
  // CopyWith method to easily update the tasks list
  TasksState copyWith(
      {List<Task>? tasks, String? selectedStatus, String? selectedPriorities,Task? selectedTask}) {
    return TasksState(
      selectedTask: selectedTask??this.selectedTask,
        tasks: tasks ?? this.tasks,
        selectedStatus: selectedStatus ?? this.selectedStatus,
        selectedPrioriti: selectedPriorities ?? this.selectedPrioriti);
  }
}

// Create a TaskStateNotifier that extends StateNotifier
class TasksStateNotifier extends StateNotifier<TasksState> {
  TasksStateNotifier()
      : super(TasksState(
            tasks: [], selectedStatus: "Status All", selectedPrioriti: "Priority All",selectedTask: null));

  // You can add methods to manipulate tasks here

  void removeTask(Task task) {
    state.tasks.where((t) => t != task).toList();
    state = state.copyWith(tasks: state.tasks);
  }

  void loadAllTask({String? searchTitle, String? searchStatus, String? searchPriority}) async {
    List data = await DatabaseHelper.getAllTasks(
        searchTitle: searchTitle, searchStatus: searchStatus,searchPriority: searchPriority);
    print("load All Task: " + data.toString());
    List<Task> tasks = data.map((json) => Task.fromMap(json)).toList();
    state = state.copyWith(tasks: tasks);
  }

  void selectStatus({required String status}) {
    state = state.copyWith(selectedStatus: status);
  }

  void selectPriorities({required String priority}) {
    state = state.copyWith(selectedPriorities: priority);
  }

  void selectedTask({required Task selectedTask}){
    state =state.copyWith(selectedTask: selectedTask);
  }
}

// Define the provider to access the TasksStateNotifier
final tasksProvider = StateNotifierProvider<TasksStateNotifier, TasksState>(
  (ref) => TasksStateNotifier(),
);
