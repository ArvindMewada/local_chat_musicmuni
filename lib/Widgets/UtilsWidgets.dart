import 'package:chat_app_musicmuni_sample/Screens/MySelfScreen.dart';
import 'package:chat_app_musicmuni_sample/Screens/OtherPersonScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home_widget.dart';

Widget titleChatWidget({BuildContext context, String text}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Text(
      "$text",
      style: TextStyle(
          color: Colors.grey[900], fontWeight: FontWeight.normal, fontSize: 25),
    ),
  );
}

Widget titleOfClientWidget(
    {BuildContext context,
    String nameYourSelf,
    String nameAnother,}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        nameTitleWidget(
            context: context, titleName: nameAnother, countOther: Home.countOtherMessage),
        dividerLineWidget(context),
        nameTitleOtherWidget(
            context: context, titleName: nameYourSelf, countMy: Home.countMyMessage),
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
      margin: EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 15),
      width: double.infinity,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "$titleName",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[900],
            ),
          ),
          countOther > 0
              ? countContainerWidget(context: context, counter: countOther)
              : Container(),
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
      margin: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 15),
      width: double.infinity,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "$titleName",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[900],
            ),
          ),
          countMy > 0
              ? countContainerWidget(context: context, counter: countMy)
              : Container(),
        ],
      ),
    ),
  );
}

Widget countContainerWidget({BuildContext context, int counter}){
  return Container(
    height: 16,
    margin: EdgeInsets.only(right: 20),
    width: 16,
    decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.all(Radius.circular(40))),
    child: Center(
      child: Text(
        "$counter",
        style: TextStyle(
            fontSize: 8,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget dividerLineWidget(BuildContext context) {
  return Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey[400],
  );
}
