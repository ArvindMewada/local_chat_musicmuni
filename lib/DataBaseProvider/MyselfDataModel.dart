import 'Keys.dart';

class MyselfDataModel {
  int id; // for unique id
  String data; // data -> text message or audio
  String time;

  MyselfDataModel({
    this.id,
    this.data,
    this.time,
  });

  factory MyselfDataModel.fromMap(Map<String, dynamic> json) => new MyselfDataModel(
    id: json[Keys.idMyself],
    data: json[Keys.dataMyself],
    time: json[Keys.timeMyself],
  );

  Map<String, dynamic> toMap() => {
    Keys.idMyself: id,
    Keys.dataMyself: data,
    Keys.timeMyself: time,
  };
}