import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app_musicmuni_sample/db/DataModel.dart';
import 'package:chat_app_musicmuni_sample/db/database_helper.dart';
import 'package:flutter/material.dart';

class OtherPersonScreen extends StatefulWidget {

  @override
  _OtherPersonScreenState createState() => _OtherPersonScreenState();
}

class _OtherPersonScreenState extends State<OtherPersonScreen> {
  List<Client> numberTruthList  = List();
  final dbHelper = DatabaseHelper.instance;

  void _fetch() async {
    // row to insert
   List<Client> list = await dbHelper.getAllClients();
   if(list != null){
     setState(() {
       numberTruthList.addAll(list);
     });
   }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
          _fetch();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Other Person'),
        elevation: 8,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child:  ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: numberTruthList.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        onPlayAudio(numberTruthList[i].firstName);
                      },
                      child: Text("firstName,,",
                        style: TextStyle(color: Colors.black,fontSize: 14),)),
                );
              },
            )
          ),
        ),
      ),
    );
  }

  void onPlayAudio(String name) async {
    print("Play time : $name");
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(name, isLocal: true);
  }

}
