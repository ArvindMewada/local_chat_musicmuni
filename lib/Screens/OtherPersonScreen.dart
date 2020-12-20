import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app_musicmuni_sample/DataBaseProvider/DataBaseHelperOtherPerson.dart';
import 'package:chat_app_musicmuni_sample/DataBaseProvider/OtherPersonDataModel.dart';
import 'package:flutter/material.dart';

class OtherPersonScreen extends StatefulWidget {

  @override
  _OtherPersonScreenState createState() => _OtherPersonScreenState();
}

class _OtherPersonScreenState extends State<OtherPersonScreen> {
  List<OtherPersonDataModel> otherPersonMessageList  = List();
  final dbHelperOtherPerson = DatabaseHelperOtherPerson.instanceOtherPerson;

  void _fetchOtherPersonAllMessage() async {
    // row to insert
   List<OtherPersonDataModel> list = await dbHelperOtherPerson.getAllMessageOtherPerson();
   if(list != null){
     setState(() {
       otherPersonMessageList.clear();
       otherPersonMessageList.addAll(list);
     });
   }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
          _fetchOtherPersonAllMessage();
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
              itemCount: otherPersonMessageList.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        onPlayAudio(otherPersonMessageList[i].data);
                      },
                      child: dateConvertMicroToDisplay(otherPersonMessageList[i].time),
                  ),
                );
              },
            )
          ),
        ),
      ),
    );
  }

  Widget  dateConvertMicroToDisplay(String displayTime){
    return  Text("$displayTime,,",
      style: TextStyle(color: Colors.black,fontSize: 14),
    );
  }
  void onPlayAudio(String name) async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(name, isLocal: true);
  }

}
