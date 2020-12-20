
import 'package:chat_app_musicmuni_sample/DataBaseProvider/Keys/Keys.dart';

class MyselfDataModel {
  int id; // for unique id
  String data; // data -> text message or audio
  String time;
  String durationOfRecord;
  bool isTypeText; // default text or change to audio

  MyselfDataModel({
    this.id,
    this.data,
    this.time,
    this.durationOfRecord,

  });

  factory MyselfDataModel.fromMap(Map<String, dynamic> json) => new MyselfDataModel(
    id: json[Keys.idMyself],
    data: json[Keys.dataMyself],
    time: json[Keys.timeMyself],
    durationOfRecord: json[Keys.durationMySelf],
  );

  Map<String, dynamic> toMap() => {
    Keys.idMyself: id,
    Keys.dataMyself: data,
    Keys.timeMyself: time,
    Keys.durationMySelf: durationOfRecord,
  };
}