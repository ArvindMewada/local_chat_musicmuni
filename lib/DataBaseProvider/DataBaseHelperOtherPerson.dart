import 'dart:io';

import 'package:chat_app_musicmuni_sample/DataBaseProvider/OtherPersonDataModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Keys.dart';

class DatabaseHelperOtherPerson {
  // make this a singleton class
  DatabaseHelperOtherPerson._privateConstructor();

  static final DatabaseHelperOtherPerson instanceOtherPerson =
      DatabaseHelperOtherPerson._privateConstructor();

  final String databaseNameOtherPerson = "OtherPersonDatabaseDB.db";
  final String tableNameOtherPerson = "other_person_table";
  final int  databaseVersionOtherPerson = 1;


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
    String pathOtherPerson = join(documentsDirectoryOtherPerson.path,
        databaseNameOtherPerson);
    return await openDatabase(pathOtherPerson,
        version: databaseVersionOtherPerson,
        onCreate: _onCreateOtherPerson);
  }

  // SQL code to create the database table
  Future _onCreateOtherPerson(Database dbOtherPerson, int version) async {
    await dbOtherPerson.execute('''
          CREATE TABLE $tableNameOtherPerson (
           ${Keys.idOtherPeron} INTEGER PRIMARY KEY,
            ${Keys.dataOtherPerson} TEXT NOT NULL,
            ${Keys.timeOtherPerson} TEXT NOT NULL 
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
      OtherPersonDataModel otherPersonDataModel) async {
    Database dbClient = await instanceOtherPerson.databaseOtherPerson;
    var result = await dbClient.rawInsert(
        'INSERT INTO $tableNameOtherPerson (${Keys.idOtherPeron}'
        ', $databaseNameOtherPerson,${Keys.timeOtherPerson} )'
        ' VALUES (\'${otherPersonDataModel.id}\', '
        '\'${otherPersonDataModel.data}'
        ', \'${otherPersonDataModel.time}\')');
    return result;
  }

  // number of message count other person
  Future<int> getCountOtherMessage() async {
    Database dbClient = await instanceOtherPerson.databaseOtherPerson;
    return Sqflite.firstIntValue(await dbClient
        .rawQuery('SELECT COUNT(*) FROM $tableNameOtherPerson'));
  }

  //all chat fetch
  Future<List> getAllMessageOtherPerson() async {
    Database dbClient = await instanceOtherPerson.databaseOtherPerson;
    var res = await dbClient.query("$tableNameOtherPerson");
    List<OtherPersonDataModel> list = res.isNotEmpty
        ? res.map((c) => OtherPersonDataModel.fromMap(c)).toList()
        : [];
    //   var result = await dbClient.rawQuery('SELECT * FROM table');
    return list;
  }

  // single chat fetch
  Future<List> getSingleRowFetchOtherPerson() async {
    Database dbClient = await instanceOtherPerson.databaseOtherPerson;
    var result =
        await dbClient.rawQuery('SELECT * FROM $tableNameOtherPerson');
    return result.toList();
  }
}
