import 'Keys.dart';

class OtherPersonDataModel {
  int id; // for unique id
  String data; // data -> text message or audio
  String time;
  bool isTypeText;
  String durationOfRecord;

  OtherPersonDataModel({
    this.id,
    this.durationOfRecord,
    this.isTypeText,
    this.data,
    this.time,
  });

  factory OtherPersonDataModel.fromMap(Map<String, dynamic> json) => new OtherPersonDataModel(
    id: json[Keys.idOtherPeron],
    data: json[Keys.dataOtherPerson],
    durationOfRecord: json[Keys.durationOtherPerson],
    time: json[Keys.timeOtherPerson],
  );

  Map<String, dynamic> toMap() => {
    Keys.idOtherPeron: id,
    Keys.durationOtherPerson: durationOfRecord,
    Keys.dataOtherPerson: data,
    Keys.timeOtherPerson: time,

  };
}