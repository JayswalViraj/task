import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/global/app_resources/app_strings.dart';
import 'package:task/global/custom_widgets/custome_loading_indicator_dialog.dart';
import 'package:task/global/services/local_notification/noti_service.dart';
import 'package:task/global/routes/app_routes_name.dart';
import 'package:task/global/utils/extentions.dart';
import 'package:task/src/tasks_page/tasks_view_controller.dart';

import '../../global/custom_widgets/custom_horizontal_list.dart';
import '../../global/custom_widgets/custom_task_card.dart';
import '../../global/models/task_model.dart';
import '../../global/services/local_database_service/database_helper.dart';
import '../../global/utils/global_functions.dart';
import '../../global/utils/theme.dart';
import '../../main.dart';
import '../task_details/task_details.dart';

class TasksView extends ConsumerStatefulWidget {
  const TasksView({super.key});

  @override
  ConsumerState<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends ConsumerState<TasksView> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(tasksProvider.notifier).loadAllTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () async {
              dynamic data = await DatabaseHelper.getAllTasks();
              print("Data: " + data.toString());
            },
            child: DefaultTextStyle(
              style:  Theme.of(context).textTheme.titleLarge!,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  WavyAnimatedText(AppStrings.taskManager,),
                ],
                isRepeatingAnimation: true,
                onTap: () {

                  },
              ),
            )),
        actions: [
          Builder(builder: (context) {
            final currentTheme = ref.watch(themeProvider);

            return IconButton(
                onPressed: () {
                  if (currentTheme.brightness == Brightness.dark) {
                    ref.read(themeProvider.notifier).state = lightTheme;
                    saveThemeMode(false);
                  } else {
                    ref.read(themeProvider.notifier).state = darkTheme;
                    saveThemeMode(true);
                  }
                },
                icon: Icon(currentTheme.brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode));
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutesName.taskAddEdit);
          }),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraint) {
        return context.isTablet
            ? Row(
                children: [
                  Container(
                    height: constraint.maxHeight,
                    width: constraint.maxWidth / 2,
                    child: CustomMobileView(searchController: searchController),
                  ),
                  Container(
                    width: 1,
                    height: constraint.maxHeight,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  Expanded(
                    child: Container(
                      height: constraint.maxHeight,
                      child: TaskDetailsPage(
                        task: ref.watch(tasksProvider).selectedTask,
                      ),
                    ),
                  )
                ],
              )
            : CustomMobileView(searchController: searchController);
      }),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class CustomMobileView extends StatelessWidget {
  const CustomMobileView({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final tasksState = ref.watch(tasksProvider);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 16.0), // Padding for spacing
              child: TextFormField(
                  onTapOutside: (value) {
                    FocusScope.of(context).requestFocus(
                        FocusNode()); // Unfocus any focused widget
                  },
                  controller: searchController,
                  onChanged: (value) {
                    ref.read(tasksProvider.notifier).loadAllTask(
                          searchTitle: value,
                          searchStatus:
                              ref.read(tasksProvider).selectedStatus ==
                                      "Status All"
                                  ? null
                                  : ref.read(tasksProvider).selectedStatus,
                          searchPriority:
                              ref.read(tasksProvider).selectedPrioriti ==
                                      "Priority All"
                                  ? null
                                  : ref.read(tasksProvider).selectedPrioriti,
                        );
                  },
                  decoration: InputDecoration(
                    hintText: "Search by title...",

                    prefixIcon: Icon(
                      Icons.search,
                    ),

                    // Adequate internal padding
                  ),
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30, // Fixed height for horizontal list
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0), // Padding for spacing

                child: Consumer(builder: (context, ref, child) {
                  final statuses = ref.watch(tasksProvider).statuses;
                  final selectedStatus = ref.read(tasksProvider).selectedStatus;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: statuses.length,
                    itemBuilder: (context, index) {
                      String status = statuses[index];
                      bool isSelected = selectedStatus == status;

                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(tasksProvider.notifier)
                              .selectStatus(status: status);
                          ref.read(tasksProvider.notifier).loadAllTask(
                                searchTitle: searchController.text,
                                searchStatus: ref
                                            .read(tasksProvider)
                                            .selectedStatus ==
                                        "Status All"
                                    ? null
                                    : ref.read(tasksProvider).selectedStatus,
                                searchPriority: ref
                                            .read(tasksProvider)
                                            .selectedPrioriti ==
                                        "Priority All"
                                    ? null
                                    : ref.read(tasksProvider).selectedPrioriti,
                              );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? GloablFuctions().getStatusColor(status)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0), // Padding for spacing

              child: SizedBox(
                height: 30, // Fixed height for horizontal list
                child: Consumer(builder: (context, ref, child) {
                  final priorities = ref.watch(tasksProvider).priorities;
                  final selectedPriority =
                      ref.read(tasksProvider).selectedPrioriti;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: priorities.length,
                    itemBuilder: (context, index) {
                      String priority = priorities[index];
                      bool isSelected = selectedPriority == priority;

                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(tasksProvider.notifier)
                              .selectPriorities(priority: priority);
                          ref.read(tasksProvider.notifier).loadAllTask(
                                searchTitle: searchController.text,
                                searchStatus: ref
                                            .read(tasksProvider)
                                            .selectedStatus ==
                                        "Status All"
                                    ? null
                                    : ref.read(tasksProvider).selectedStatus,
                                searchPriority: ref
                                            .read(tasksProvider)
                                            .selectedPrioriti ==
                                        "Priority All"
                                    ? null
                                    : ref.read(tasksProvider).selectedPrioriti,
                              );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? GloablFuctions().getStatusColor(priority)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Center(
                            child: Text(
                              priority,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.read(tasksProvider.notifier).loadAllTask(
                      searchTitle: searchController.text,
                      searchStatus:
                          ref.read(tasksProvider).selectedStatus == "Status All"
                              ? null
                              : ref.read(tasksProvider).selectedStatus,
                      searchPriority:
                          ref.read(tasksProvider).selectedPrioriti ==
                                  "Priority All"
                              ? null
                              : ref.read(tasksProvider).selectedPrioriti);
                },
                child: tasksState.tasks.isEmpty
                    ? Container(
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                        )),
                      )
                    : Scrollbar(
                        thickness: 3.0,
                        thumbVisibility: true,
                        child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: tasksState.tasks.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      AppRoutesName.taskAddEdit,
                                      arguments:
                                          tasksState.tasks[index].toMap());
                                },
                                child: CustomTaskCard(
                                  viewFunction: () {
                                    if (context.isTablet == true) {
                                      ref
                                          .read(tasksProvider.notifier)
                                          .selectedTask(
                                              selectedTask:
                                                  tasksState.tasks[index]);
                                    } else {
                                      Navigator.of(context).pushNamed(
                                          AppRoutesName.taskDetails,
                                          arguments: tasksState.tasks[index]);
                                    }
                                  },
                                  deleteFunction: () {
                                    // Function to show delete confirmation dialog
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Delete Task?"),
                                        content: Text(
                                            "Are you sure you want to delete this task?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);

                                              await DatabaseHelper.deleteTask(
                                                  tasksState.tasks[index].id!);

                                              ref.read(tasksProvider.notifier).loadAllTask(
                                                  searchTitle:
                                                      searchController.text,
                                                  searchStatus: ref
                                                              .read(
                                                                  tasksProvider)
                                                              .selectedStatus ==
                                                          "Status All"
                                                      ? null
                                                      : ref
                                                          .read(tasksProvider)
                                                          .selectedStatus,
                                                  searchPriority: ref
                                                              .read(
                                                                  tasksProvider)
                                                              .selectedPrioriti ==
                                                          "Priority All"
                                                      ? null
                                                      : ref
                                                          .read(tasksProvider)
                                                          .selectedPrioriti);
                                            },
                                            child: Text("Delete",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  id: tasksState.tasks[index].id!,
                                  title: tasksState.tasks[index].title,
                                  date: tasksState.tasks[index].date
                                      .toDDMMMYYYY(),
                                  time: tasksState.tasks[index].time
                                      .to12HourFormatDayOfTime(),
                                  status: tasksState.tasks[index].state,
                                  priority: tasksState.tasks[index].priority,
                                ),
                              );
                            }),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
