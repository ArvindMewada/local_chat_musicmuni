import '../Keys/Keys.dart';

class OtherPersonDataModel {
  int id; // for unique id
  String data; // data -> text message or audio
  String time;
  String isTypeText; // default text or change to audio
  String durationOfRecord;
  String isMySelf;

  OtherPersonDataModel({
    this.id,
    this.durationOfRecord,
    this.isTypeText,
    this.data,
    this.time,
    this.isMySelf
  });

  factory OtherPersonDataModel.fromMap(Map<String, dynamic> json) => new OtherPersonDataModel(
    id: json[Keys.idOtherPeron],
    data: json[Keys.dataOtherPerson],
    durationOfRecord: json[Keys.durationOtherPerson],
    time: json[Keys.timeOtherPerson],
    isMySelf: json[Keys.isMyselfType],
    isTypeText: json[Keys.isTypeText],
  );

  Map<String, dynamic> toMap() => {
    Keys.idOtherPeron: id,
    Keys.durationOtherPerson: durationOfRecord,
    Keys.dataOtherPerson: data,
    Keys.timeOtherPerson: time,
    Keys.isMyselfType: isMySelf,
    Keys.isTypeText: isTypeText,

  };
}