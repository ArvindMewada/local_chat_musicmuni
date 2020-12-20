import 'package:bubble/bubble.dart';
import 'package:chat_app_musicmuni_sample/DataBaseProvider/DataModel/OtherPersonDataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MySelfWidget.dart';
import 'UtilsWidgets.dart';

Widget dateConvertMicroToDisplay({BuildContext context, OtherPersonDataModel otherPersonDataModel}) {
  if (otherPersonDataModel != null &&
      otherPersonDataModel.isMySelf != null &&
      otherPersonDataModel.isMySelf.toString().length > 2) {
    if (otherPersonDataModel != null &&
        otherPersonDataModel.isTypeText != null &&
        otherPersonDataModel.isTypeText.toString().length > 2) {
      return sentWidgetTextField(context:context, otherPersonDataModel: otherPersonDataModel);
    } else {
      return sendAudioFileWidget(context: context, otherPersonDataModel:  otherPersonDataModel);
    }
  } else if (otherPersonDataModel != null &&
      otherPersonDataModel.isTypeText.toString().length > 0) {
    return receiveTextWidget(context: context, otherPersonDataModel:  otherPersonDataModel);
  } else {
    return receiveAudioWidget(context: context, otherPersonDataModel:  otherPersonDataModel);
  }
}


Widget sentWidgetTextField({BuildContext context, OtherPersonDataModel otherPersonDataModel}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Bubble(
        padding: BubbleEdges.all(8),
        alignment: Alignment.bottomLeft,
        nip: BubbleNip.leftBottom,
        elevation: 8,
        color: Colors.blue[600],
        child: Text(
          "${otherPersonDataModel.data}",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 16),
        child: Text(
          "${otherPersonDataModel.time}",
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600]),
        ),
      ),
    ],
  );
}

Widget sendAudioFileWidget({BuildContext context, OtherPersonDataModel otherPersonDataModel}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Bubble(
          padding: BubbleEdges.all(8),
          alignment: Alignment.bottomLeft,
          nip: BubbleNip.leftBottom,
          elevation: 8,
          color: Colors.blue[600],
          child:
          audioRecordWidgetsReceive(context, otherPersonDataModel)),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 16),
        child: Text(
          "${otherPersonDataModel.time}",
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600]),
        ),
      ),
    ],
  );
}

Widget audioRecordWidgetsReceive(
    BuildContext context, OtherPersonDataModel otherPersonDataModel) {
  return Container(
    width: 150,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "${otherPersonDataModel.durationOfRecord.substring(2, 7)}",
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
        Container(
          color: Colors.white,
          height: 1,
          width: 50,
        ),
        GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              HapticFeedback.lightImpact();
              onPlayAudio(otherPersonDataModel.data);
            },
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 25,
            )),
      ],
    ),
  );
}


Widget receiveTextWidget({BuildContext context, OtherPersonDataModel otherPersonDataModel}){
  return Container(
    margin: EdgeInsets.only(top: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Bubble(
          padding: BubbleEdges.all(8),
          alignment: Alignment.topRight,
          nip: BubbleNip.rightBottom,
          elevation: 8,
          color: Colors.blue[400],
          child: Text(
            "${otherPersonDataModel.data}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 16),
          child: Text(
            "${otherPersonDataModel.time}",
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: Colors.grey[600]),
          ),
        ),
      ],
    ),
  );
}

Widget receiveAudioWidget({BuildContext context, OtherPersonDataModel otherPersonDataModel}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Bubble(
          padding: BubbleEdges.all(8),
          alignment: Alignment.topRight,
          nip: BubbleNip.rightBottom,
          elevation: 8,
          color: Colors.blue[400],
          child: audioRecordWidgets(context, otherPersonDataModel)),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 16),
        child: Text(
          "${otherPersonDataModel.time}",
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600]),
        ),
      ),
    ],
  );
}