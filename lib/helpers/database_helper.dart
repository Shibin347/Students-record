import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutterproject1/models/recordmodel.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  String recordTable = 'record_table';
  String colId = 'id';
  String colName = 'name';
  String colGuardian = 'guardian';
  String colTeacher = 'teacher';
  String colAge = 'age';

  Future<Database> initializeDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'students_record.db';
    final studentRecordDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return studentRecordDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE $recordTable('
        '$colId INTEGER PRIMARY KEY,'
        '$colName TEXT,'
        '$colGuardian TEXT,'
        '$colTeacher TEXT,'
        '$colAge TEXT,);');
  }

  Future<List<Map<String, dynamic>>> getRecordMapList() async {
    Database? db = await initializeDatabase();
    final List<Map<String, dynamic>> result = await db.query(recordTable);
    return result;
  }

  Future<List<Record>> getRecordList() async {
    final List<Map<String, dynamic>> recordMapList = await getRecordMapList();
    final List<Record> recordList = [];
    recordMapList.forEach((recordMap) {
      recordList.add(Record.fromJson(recordMap));
    });
    return recordList;
  }

  Future<void> insertRecord(Record record) async {
    Database? db = await initializeDatabase();
    await db.insert(recordTable, record.toJson());
  }

  Future<void> updateRecord(Record record) async {
    Database? db = await initializeDatabase();
    await db.update(recordTable, record.toJson(),
        where: '$colId = ?', whereArgs: [record.id]);
  }

  Future<void> deleteRecord(int id) async {
    Database? db = await initializeDatabase();
    await db.delete(recordTable, where: '$colId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> searchQuery(String text) async {
    Database? db = await initializeDatabase();
    final List<Map<String, dynamic>> result = await db
        .rawQuery("SELECT * FROM $recordTable WHERE name LIKE '%$text%'");

    return result;
  }

  Future<List<Record>> search(String text) async {
    final List<Map<String, dynamic>> recordMapList = await searchQuery(text);
    final List<Record> recordList = [];
    recordMapList.forEach((recordMap) {
      recordList.add(Record.fromJson(recordMap));
    });
    return recordList;
  }
}
