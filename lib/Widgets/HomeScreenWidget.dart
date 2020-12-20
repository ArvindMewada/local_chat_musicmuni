import 'package:chat_app_musicmuni_sample/Screens/MySelfScreen.dart';
import 'package:chat_app_musicmuni_sample/Screens/OtherPersonScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'UtilsWidgets.dart';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              titleChatWidget(context: context, text: "Chat"),
              titleOfClientWidget(
                context: context,
                nameAnother: "Other Person",
                nameYourSelf: "My Self",
                countOther: OtherPersonScreen.countOtherMessage,
                countMy: MySelfScreen.countMyMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }


}
