import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Utils/Util.dart';
import 'Widgets/UtilsWidgets.dart';
import 'db/database_helper.dart';

class Home extends StatefulWidget {
  static int countOtherMessage = 0;
 @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  // Create a teoller and use it to retrieve the current value
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      getCountOtherMessage(context);
    });
    super.initState();
  }


  void getCountOtherMessage(BuildContext context) async {
    int a =  await dbHelper.getCountOtherDB();
    setState(() {
      Home.countOtherMessage = a;
    });
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
              titleChatWidget(context: context,text: "Chat"),
              titleOfClientWidget(context: context, nameAnother: "Other Person"
                  , nameYourSelf: "My Self", countOther: Home.countOtherMessage, countMySelf: 0),
            ],
          ),
        ),
      ),
    );
  }



}