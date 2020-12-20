import 'dart:io';

import 'package:chat_app_musicmuni_sample/DataBaseProvider/DataModel/MyselfDataModel.dart';
import 'package:chat_app_musicmuni_sample/DataBaseProvider/DataModel/OtherPersonDataModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:chat_app_musicmuni_sample/DataBaseProvider/Keys/Keys.dart';

class DatabaseHelperMySelf {
  // make this a singleton class
  DatabaseHelperMySelf._privateConstructor();

  static final DatabaseHelperMySelf instanceMySelf =
  DatabaseHelperMySelf._privateConstructor();

  final String databaseNameMySelf = "DataBaseMySelf.db";
  final String tableNameMySelf = "table_my_self";
  final int databaseVersionMySelf = 1;

  // only have a single app-wide reference to the database
  static Database _databaseMy;

  Future<Database> get databaseMySelf async {
    if (_databaseMy != null) return _databaseMy;
    // lazily instantiate the db the first time it is accessed
    _databaseMy = await _initDatabaseMySelf();
    return _databaseMy;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabaseMySelf() async {
    Directory documentsDirectoryMySelf =
    await getApplicationDocumentsDirectory();
    String pathMySelf =
    join(documentsDirectoryMySelf.path, databaseNameMySelf);
    return await openDatabase(pathMySelf,
        version: databaseVersionMySelf, onCreate: _onCreateOtherPerson);
  }

  // SQL code to create the database table
  Future _onCreateOtherPerson(Database dbOtherPerson, int version) async {
    await dbOtherPerson.execute('''
          CREATE TABLE $tableNameMySelf (
           ${Keys.idMyself} INTEGER PRIMARY KEY,
            ${Keys.dataMyself} TEXT NOT NULL,
            ${Keys.durationMySelf} TEXT NOT NULL,
            ${Keys.timeMyself} TEXT NOT NULL 
          )
          ''');
  }

  // create database and entry data
  Future<int> createMySelfDB(Map<String, dynamic> map) async {
    Database dbClient = await instanceMySelf.databaseMySelf;
    var result = await dbClient.insert(tableNameMySelf, map);
    return result;
  }

  // only row insert
  Future<int> newRowInsertExistingTableInMySelf(
      MyselfDataModel myselfDataModel) async {
    Database dbClient = await instanceMySelf.databaseMySelf;
    var result = await dbClient
        .rawInsert('INSERT INTO $tableNameMySelf (${Keys.idMyself}'
        ', $databaseNameMySelf,${Keys.timeMyself},${Keys.durationMySelf} )'
        ' VALUES (\'${myselfDataModel.id}\', '
        '\'${myselfDataModel.data}'
        '\'${myselfDataModel.durationOfRecord}'
        ', \'${myselfDataModel.time}\')');
    return result;
  }

  // number of message count other person
  Future<int> getCountMySelfMessage() async {
    Database dbClient = await instanceMySelf.databaseMySelf;
    int count = Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableNameMySelf'));
    return count;
  }

  //all chat fetch
  Future<List> getAllMessageMySelf() async {
    Database dbClient = await instanceMySelf.databaseMySelf;
    var res = await dbClient.query("$tableNameMySelf");
    List<OtherPersonDataModel> list = res.isNotEmpty
        ? res.map((c) => MyselfDataModel.fromMap(c)).toList()
        : [];
    //   var result = await dbClient.rawQuery('SELECT * FROM table');
    return list;
  }

  // single chat fetch
  Future<List> getSingleRowFetchMySelf() async {
    Database dbClient = await instanceMySelf.databaseMySelf;
    var result = await dbClient.rawQuery('SELECT * FROM $tableNameMySelf');
    return result.toList();
  }
}
