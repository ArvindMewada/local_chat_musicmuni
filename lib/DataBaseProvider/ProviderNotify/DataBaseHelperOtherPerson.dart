import 'dart:io';

import 'package:chat_app_musicmuni_sample/DataBaseProvider/DataModel/DataModelAll.dart';
import 'package:chat_app_musicmuni_sample/DataBaseProvider/Keys/Keys.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperOtherPerson {
  // make this a singleton class
  DatabaseHelperOtherPerson._privateConstructor();

  static final DatabaseHelperOtherPerson instanceOtherPerson =
      DatabaseHelperOtherPerson._privateConstructor();

  final String databaseNameOtherPerson = "DataBaseAll.db";
  final String tableNameOtherPerson = "table_data_base_all";
  final int databaseVersionOtherPerson = 1;

  // only have a single app-wide reference to the database
  static Database _databaseOther;

  Future<Database> get databaseOtherPerson async {
    if (_databaseOther != null) return _databaseOther;
    // lazily instantiate the db the first time it is accessed
    _databaseOther = await _initDatabaseOtherPerson();
    return _databaseOther;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabaseOtherPerson() async {
    Directory documentsDirectoryOtherPerson =
        await getApplicationDocumentsDirectory();
    String pathOtherPerson =
        join(documentsDirectoryOtherPerson.path, databaseNameOtherPerson);
    return await openDatabase(pathOtherPerson,
        version: databaseVersionOtherPerson, onCreate: _onCreateOtherPerson);
  }

  // SQL code to create the database table
  Future _onCreateOtherPerson(Database dbOtherPerson, int version) async {
    await dbOtherPerson.execute('''
          CREATE TABLE $tableNameOtherPerson (
           ${Keys.idOtherPeron} INTEGER PRIMARY KEY,
            ${Keys.dataOtherPerson} TEXT NOT NULL,
            ${Keys.durationOtherPerson} TEXT NOT NULL,
            ${Keys.timeOtherPerson} TEXT NOT NULL,
            ${Keys.isMyselfType} TEXT NOT NULL,
            ${Keys.isTypeText} TEXT NOT NULL

          )
          ''');
  }

  // create database and entry data
  Future<int> createOtherPersonDB(Map<String, dynamic> map) async {
    Database dbClient = await instanceOtherPerson.databaseOtherPerson;
    var result = await dbClient.insert(tableNameOtherPerson, map);
    return result;
  }

  // only row insert
  Future<int> newRowInsertExistingTableInOtherPerson(
      DataModelAll otherPersonDataModel) async {
    Database dbClient = await instanceOtherPerson.databaseOtherPerson;
    var result = await dbClient.rawInsert(
        'INSERT INTO $tableNameOtherPerson (${Keys.idOtherPeron}'
        ', $databaseNameOtherPerson,${Keys.timeOtherPerson},${Keys.durationOtherPerson} )'
        ' VALUES (\'${otherPersonDataModel.id}\', '
        '\'${otherPersonDataModel.data}'
        '\'${otherPersonDataModel.durationOfRecord}'
        ', \'${otherPersonDataModel.time}\')');
    return result;
  }

  // number of message count other person
  Future<int> getCountOtherMessage() async {
    Database dbClient = await instanceOtherPerson.databaseOtherPerson;
    int count = Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableNameOtherPerson'));
    return count;
  }

  //all chat fetch
  Future<List> getAllMessageOtherPerson() async {
    Database dbClient = await instanceOtherPerson.databaseOtherPerson;
    var res = await dbClient.query("$tableNameOtherPerson");
    List<DataModelAll> list =
        res.isNotEmpty ? res.map((c) => DataModelAll.fromMap(c)).toList() : [];
    //   var result = await dbClient.rawQuery('SELECT * FROM table');
    return list;
  }

  // single chat fetch
  Future<List> getSingleRowFetchOtherPerson() async {
    Database dbClient = await instanceOtherPerson.databaseOtherPerson;
    var result = await dbClient.rawQuery('SELECT * FROM $tableNameOtherPerson');
    return result.toList();
  }
}
