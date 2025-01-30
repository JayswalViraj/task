import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task/global/services/local_notification/noti_service.dart';
import 'package:task/global/utils/theme.dart';
import 'package:task/src/add_edit_task/add_edit_task.dart';
import 'package:task/src/task_details/task_details.dart';
import 'package:task/src/tasks_page/tasks_view.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'global/models/task_model.dart';
import 'global/routes/app_routes_name.dart';

// Define a StateProvider to store the current theme mode
final themeProvider = StateProvider<ThemeData>((ref) {
  final box = Hive.box('settings');
  final isDarkMode = box.get('isDarkMode', defaultValue: false);

  print("is Dark mode: " + isDarkMode.toString());
  return isDarkMode ? darkTheme : lightTheme; // Default theme is light
});

void configureLocalTimeZone() {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata')); // Set your time zone
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureLocalTimeZone();
  NotiService().initializeNotification();
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('settings'); // Open the settings box to store preferences

  runApp(ProviderScope(child: const MyApp()));
}

// Save the theme setting to Hive
void saveThemeMode(bool isDarkMode) async {
  var box = await Hive.openBox('settings');
  await box.put('isDarkMode', isDarkMode);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    final currentTheme = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: currentTheme.brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light, // Dynamically set the theme mode
      initialRoute: AppRoutesName.tasksPage,
      routes: {
        AppRoutesName.tasksPage: (context) => TasksView(),
        AppRoutesName.taskAddEdit: (context) => AddEditTask(),
        AppRoutesName.taskDetails: (context) {
          final Task? task =
              ModalRoute.of(context)!.settings.arguments as Task?;

          return TaskDetailsPage(task: task);
        },
      },
    );
  }
}
