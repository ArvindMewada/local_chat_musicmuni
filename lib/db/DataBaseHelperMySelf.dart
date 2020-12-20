// import 'dart:io';
//
// import 'package:chat_app_musicmuni_sample/db/MyselfDataModel.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DatabaseHelperOtherPerson {
//
//   // make this a singleton class
//   DatabaseHelperOtherPerson._privateConstructor();
//   static final DatabaseHelperOtherPerson instance = DatabaseHelperOtherPerson._privateConstructor();
//
//   // only have a single app-wide reference to the database
//   static Database _database;
//   Future<Database> get database async {
//     if (_database != null) return _database;
//     // lazily instantiate the db the first time it is accessed
//     _database = await _initDatabase();
//     return _database;
//   }
//
//   // this opens the database (and creates it if it doesn't exist)
//   _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseName);
//     return await openDatabase(path,
//         version: _databaseVersion,
//         onCreate: _onCreate);
//   }
//
//   // SQL code to create the database table
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//           CREATE TABLE $table (
//             $columnId INTEGER PRIMARY KEY,
//             $columnName TEXT NOT NULL
//           )
//           ''');
//   }
//
//
//   // create database and entry data
//   Future<int> createOtherDB(Map<String, dynamic> map) async {
//     Database dbClient = await instance.database;
//     var result = await dbClient.insert(table, map);
//     return result;
//   }
//
//   // only row insert
//   Future<int> newOtherDbRowInsert(Client newClient) async {
//     Database dbClient = await instance.database;
//        var result = await dbClient.rawInsert(
//        'INSERT INTO $table ($columnId, $columnName) VALUES (\'${newClient.id}\', \'${newClient.firstName}\')');
//        print("${newClient.firstName}");
//     return result;
//   }
//
//   // number of message count other person
//   Future<int> getCountOtherDB() async {
//     Database dbClient = await instance.database;
//     return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $table'));
//   }
//
//   // number of message count my self
//   Future<int> getCountMySelfDB() async {
//     Database dbClient = await instance.database;
//     return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $table'));
//   }
//
//   //all chat fetch
//   Future<List> getAllClientsOther() async {
//     Database dbClient = await instance.database;
//     var res = await dbClient.query("$table");
//     List<Client> list =
//     res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
//     //   var result = await dbClient.rawQuery('SELECT * FROM table');
//     return list;
//   }
//
//   //all chat fetch
//   Future<List> getAllClientsMySelf() async {
//     Database dbClient = await instance.database;
//     var res = await dbClient.query("$table");
//     List<Client> list =
//     res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
//     //   var result = await dbClient.rawQuery('SELECT * FROM table');
//     return list;
//   }
//
//
//   // single chat fetch
//   Future<List> getSingleChatAccess() async {
//     Database dbClient = await instance.database;
//    var result = await dbClient.rawQuery('SELECT * FROM $table');
//     return result.toList();
//   }
//
// }