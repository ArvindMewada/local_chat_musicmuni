import 'package:chat_app_musicmuni_sample/db/UtilsDBProvider/DbProviderUtils.dart';
import 'package:flutter/cupertino.dart';

class OtherPersonDataModel {
  int id;
  String data;
  String time;

  OtherPersonDataModel({
    this.id,
    this.data,
    this.time,
  });

  factory OtherPersonDataModel.fromMap(Map<String, dynamic> json) => new OtherPersonDataModel(
    id: json[UtilsDatabase.idOther],
    data: json[UtilsDatabase.dataOther],
    time: json[UtilsDatabase.timeOther],
  );

  Map<String, dynamic> toMap() => {
    UtilsDatabase.idOther: id,
    UtilsDatabase.dataOther: data,
    UtilsDatabase.timeOther: time,

  };
}