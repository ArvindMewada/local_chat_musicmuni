import 'package:chat_app_musicmuni_sample/Screens/MySelfScreen.dart';
import 'package:chat_app_musicmuni_sample/Screens/OtherPersonScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget titleChatWidget({BuildContext context, String text}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Text(
      "$text",
      style: TextStyle(
          color: Colors.grey[700], fontWeight: FontWeight.normal, fontSize: 24),
    ),
  );
}

Widget titleOfClientWidget(
    {BuildContext context,
    String nameYourSelf,
    String nameAnother,
    int countOther,
    int countMySelf}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        nameTitleWidget(
            context: context, titleName: nameAnother, countOther: countOther),
        dividerLineWidget(context),
        nameTitleOtherWidget(
            context: context, titleName: nameYourSelf,countMy: countMySelf),
        dividerLineWidget(context),
      ],
    ),
  );
}

Widget nameTitleWidget(
    {BuildContext context, String titleName, int countOther}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtherPersonScreen()),
      );
    },
    behavior: HitTestBehavior.translucent,
    child: Container(
      margin: EdgeInsets.only(top: 30, left: 16, right: 16),
      width: double.infinity,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "$titleName",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          countOther >  0 ?  Text(
            "$countOther",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ) : Container(),
        ],
      ),
    ),
  );

}

Widget nameTitleOtherWidget(
    {BuildContext context, String titleName, int countMy}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MySelfScreen()),
      );
    },
    behavior: HitTestBehavior.translucent,
    child: Container(
      margin: EdgeInsets.only(top: 30, left: 16, right: 16),
      width: double.infinity,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "$titleName",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          countMy >  0 ? Text(
            "$countMy",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ) : Container(),
        ],
      ),
    ),
  );
}

Widget dividerLineWidget(BuildContext context) {
  return Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey[900],
  );
}
