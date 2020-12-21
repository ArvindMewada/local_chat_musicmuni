import '../Keys/Keys.dart';

class DataModelAll {
  int id; // for unique id
  String data; // data -> text message or audio
  String time;
  String isTypeText; // default text or change to audio
  String durationOfRecord; // duration if record audio
  String isMySelf; // check sent or received type

  DataModelAll(
      {this.id,
      this.durationOfRecord,
      this.isTypeText,
      this.data,
      this.time,
      this.isMySelf});

  factory DataModelAll.fromMap(Map<String, dynamic> json) => new DataModelAll(
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
