import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'task_db.db'; // Changed to camelCase
  static const String tableName = 'tasks'; // Changed to camelCase

  // Column names (still in snake_case for DB consistency)
  static const String columnId = 'id'; // Changed to camelCase
  static const String columnDate = 'date'; // Changed to camelCase
  static const String columnPriority = 'priority'; // Changed to camelCase
  static const String columnState = 'state'; // Changed to camelCase
  static const String columnTitle = 'title'; // Changed to camelCase
  static const String columnDescription = 'description'; // Changed to camelCase
  static const String columnTime = 'time';

  // Singleton pattern
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName); // Using `join` here
    return await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('ALTER TABLE tasks ADD COLUMN time TEXT');
    }
  }

  // Create table without 'time' column
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDate TEXT,
        $columnPriority TEXT,
        $columnState TEXT,
        $columnTitle TEXT,
        $columnDescription TEXT,
        $columnTime TEXT
      )
    ''');
  }

  // Insert a new task (only with date)
  static Future<int> insertTask(Map<String, dynamic> task) async {
    Database db = await database;
    await printTableSchema(db, 'tasks');

    return await db.insert(tableName, task);
  }

  static Future<List<Map<String, dynamic>>> getAllTasks(
      {String? searchTitle, // Title to search (optional)
      String? searchStatus, // Status to filter by (optional)
      String? searchPriority //Priority to filter by
      }) async {
    Database db = await database;

    // Base SQL query to get all tasks sorted by date and time in ascending order
    String query = 'SELECT * FROM $tableName WHERE 1=1';

    List<dynamic> parameters = [];

    // Add title filter if searchTitle is provided
    if (searchTitle != null && searchTitle.isNotEmpty) {
      query += ' AND $columnTitle LIKE ?';
      parameters.add('%$searchTitle%'); // Use LIKE for partial matching
    }

    // Add status filter if searchStatus is provided
    if (searchStatus != null && searchStatus.isNotEmpty) {
      query += ' AND $columnState = ?';
      parameters.add(searchStatus); // Exact match for status
    }

    // Add priority filter if searchPriority is provided
    if (searchPriority != null && searchPriority.isNotEmpty) {
      query += ' AND $columnPriority = ?';
      parameters.add(searchPriority); // Exact match for status
    }

    // Add order by clause to sort by date and time
    query += ' ORDER BY $columnDate ASC, $columnTime ASC';

    // Execute the query with parameters and return the result
    return await db.rawQuery(query, parameters);
  }

  // Edit a task
  static Future<int> updateTask(
      {required int id,
      required String date,
      required String priority,
      required String state,
      required String title,
      required String description,
      required String time}) async {
    Database db = await database;
    Map<String, dynamic> updatedTask = {
      columnDate: date,
      columnPriority: priority,
      columnState: state,
      columnTitle: title,
      columnDescription: description,
      columnTime: time
    };
    return await db.update(
      tableName,
      updatedTask,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Delete a task
  static Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  static Future<void> printTableSchema(Database db, String tableName) async {
    List<Map<String, dynamic>> result =
        await db.rawQuery("PRAGMA table_info($tableName)");

    for (var row in result) {
      print(
          "Column: ${row['name']}, Type: ${row['type']}, Nullable: ${row['notnull'] == 0}");
    }
  }
}
