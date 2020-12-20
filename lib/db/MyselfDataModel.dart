import 'UtilsDBProvider/DbProviderUtils.dart';

class MyselfDataModel {
  int id;
  String data;
  String time;

  MyselfDataModel({
    this.id,
    this.data,
    this.time,
  });

  factory MyselfDataModel.fromMap(Map<String, dynamic> json) => new MyselfDataModel(
    id: json[UtilsDatabase.idMySelf],
    data: json[UtilsDatabase.dataMySelf],
    time: json[UtilsDatabase.timeMySelf],
  );

  Map<String, dynamic> toMap() => {
    UtilsDatabase.idMySelf: id,
    UtilsDatabase.dataMySelf: data,
    UtilsDatabase.timeMySelf: time,
  };
}