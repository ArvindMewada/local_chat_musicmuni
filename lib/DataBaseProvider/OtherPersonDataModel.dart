import 'Keys.dart';

class OtherPersonDataModel {
  int id; // for unique id
  String data; // data -> text message or audio
  String time;

  OtherPersonDataModel({
    this.id,
    this.data,
    this.time,
  });

  factory OtherPersonDataModel.fromMap(Map<String, dynamic> json) => new OtherPersonDataModel(
    id: json[Keys.idOtherPeron],
    data: json[Keys.dataOtherPerson],
    time: json[Keys.timeOtherPerson],
  );

  Map<String, dynamic> toMap() => {
    Keys.idOtherPeron: id,
    Keys.dataOtherPerson: data,
    Keys.timeOtherPerson: time,

  };
}