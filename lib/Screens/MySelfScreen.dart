import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bubble/bubble.dart';
import 'package:chat_app_musicmuni_sample/DataBaseProvider/DataModel/OtherPersonDataModel.dart';
import 'package:chat_app_musicmuni_sample/DataBaseProvider/ProviderNotify/DataBaseHelperOtherPerson.dart';
import 'package:chat_app_musicmuni_sample/Screens/OtherPersonScreen.dart';
import 'package:chat_app_musicmuni_sample/Utils/Util.dart';
import 'package:chat_app_musicmuni_sample/Widgets/MySelfWidget.dart';
import 'package:chat_app_musicmuni_sample/Widgets/UtilsWidgets.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class MySelfScreen extends StatefulWidget {
  static int countMyMessage = 0;
  final LocalFileSystem localFileSystem;

  MySelfScreen({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _MySelfScreenState createState() => _MySelfScreenState();
}

class _MySelfScreenState extends State<MySelfScreen> {
  // Create a teoller and use it to retrieve the current value
  final dbHelperOtherPerson = DatabaseHelperOtherPerson.instanceOtherPerson;
  final mySelfController = TextEditingController();
  int countMy = 0;
  List<OtherPersonDataModel> fetchList = List();
  bool isSendShow = false, isListShow = false, isReceivedList = false;
  List<OtherPersonDataModel> otherDataList = List();
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  GlobalKey itemKey;
  ScrollController scrollController;
  bool fullWidthAudioRecord = false;

  @override
  initState() {
    super.initState();
    _init();
    mySelfController.addListener(controlOfInputTextField);
    itemKey = GlobalKey();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllMessageFetch(context);
      countAllClear(context);
    });
  }

  void countAllClear(BuildContext context) {
    setState(() {
      MySelfScreen.countMyMessage = 0;
      OtherPersonScreen.countOtherMessage = 0;
    });
  }

  void controlOfInputTextField() {
    if (mySelfController.text != null &&
        mySelfController.text.toString().length > 0) {
      setState(() {
        isSendShow = true;
      });
    } else {
      setState(() {
        isSendShow = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    mySelfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('My Self'),
        elevation: 8,
      ),
      bottomNavigationBar: fullWidthAudioRecord
          ? audioRecordOpen()
          : bottomNavWhenTextFieldOpen(context),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: sentMessageListBuild(context: context),
        ),
      ),
    );
  }

  Widget bottomNavWhenTextFieldOpen(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 16, top: 8),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            inputFiledBothSideChat(context, mySelfController),
            sendAndMicIconsWidget(context),
          ],
        ),
      ),
    );
  }

  Widget sendAndMicIconsWidget(BuildContext context){
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          if (isSendShow) {
            // todo insert text file
            _insertOtherPersonLocalSaved(
                dataFileSaveInLocal: mySelfController.text);
          } else {
            // todo insert audio file
            setState(() {
              fullWidthAudioRecord = true;
            });
            permissionCheckAudioAndStorage();
          }
        },
        behavior: HitTestBehavior.translucent,
        child:iconsSendAndRecordWidget(context: context, isSendShow: isSendShow),
      ),
    );
  }

  Widget sentMessageListBuild({BuildContext context}) {
    return Column(
      children: <Widget>[
        fetchList != null
            ? listBuilderWidget(context, fetchList)
            : Container(),
        otherDataList != null
            ? listBuilderWidget(context, otherDataList)
            : Container(),
      ],
    );
  }

  Widget listBuilderWidget(BuildContext context, otherDataList ){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      controller: scrollController,
      shrinkWrap: true,
      itemCount: otherDataList.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: dateConvertMicroToDisplay(context, otherDataList[i]),
        );
      },
    );
  }

  Widget audioRecordOpen() {
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
      height: 50,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.all(Radius.circular(100))),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            cancelButtonRecord(context),
            timeRecordWidget(context),
            audioSendWidget(context),
          ],
        ),
      ),
    );
  }

  Widget cancelButtonRecord(BuildContext context){
    return  Expanded(
      flex: 1,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          HapticFeedback.lightImpact();
          if (_currentStatus == RecordingStatus.Recording) {
            _init();
            setState(() {
              fullWidthAudioRecord = false;
            });
          }
        },
        child: Center(
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget timeRecordWidget(BuildContext context){
    return Expanded(
      flex: 5,
      child: Center(
        child: Text(
          "${_current?.duration?.inSeconds.toString()}",
          style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget audioSendWidget(BuildContext context){
    return Expanded(
        flex: 1,
        child: GestureDetector(
            onTap: () {
              // todo stop audio and saved local
              HapticFeedback.lightImpact();
              if (_currentStatus == RecordingStatus.Recording) {
                _stop();
                setState(() {
                  fullWidthAudioRecord = false;
                });
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Center(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 25,
                ))));
  }


  void _insertOtherPersonLocalSaved(
      {String dataFileSaveInLocal, String durationRecordTime}) async {
    // row to insert
    OtherPersonDataModel otherPersonDataModel = OtherPersonDataModel();
    dataModelSavedLocal(durationRecordTime: durationRecordTime,
        dataFileSaveInLocal: dataFileSaveInLocal, otherPersonDataModel: otherPersonDataModel);
    setState(() {
      isListShow = true;
      mySelfController.text = "";
      otherDataList.add(otherPersonDataModel);
    });

    if (scrollController.hasClients)
      scrollController.animateTo(
        0.0,
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 300),
      );
    await dbHelperOtherPerson.createOtherPersonDB(otherPersonDataModel.toMap());
    countMy++;
    getCountOtherMessage(context);
  }

  void dataModelSavedLocal({String dataFileSaveInLocal, String durationRecordTime,
    OtherPersonDataModel otherPersonDataModel}){
    otherPersonDataModel.id = DateTime.now().millisecondsSinceEpoch;
    if (durationRecordTime != null &&
        durationRecordTime.toString().length > 0) {
      otherPersonDataModel.durationOfRecord = durationRecordTime;
    } else {
      otherPersonDataModel.durationOfRecord = "";
    }
    if (isSendShow) {
      otherPersonDataModel.isTypeText = "true";
      otherPersonDataModel.data = dataFileSaveInLocal.toString();
    } else {
      otherPersonDataModel.isTypeText = "";
      otherPersonDataModel.data = dataFileSaveInLocal.toString();
    }
    String formattedDate = DateFormat('h:mm a').format(DateTime.now());
    otherPersonDataModel.time = formattedDate;
    otherPersonDataModel.isMySelf = "myself";
  }

  void getAllMessageFetch(BuildContext context) async {
    List<OtherPersonDataModel> fetchListTemp =
        await dbHelperOtherPerson.getAllMessageOtherPerson();
    if (fetchListTemp != null && fetchListTemp.length > 0) {
      setState(() {
        fetchList.clear();
        fetchList.addAll(fetchListTemp);
        isReceivedList = true;
      });
    }
  }


  void getCountOtherMessage(BuildContext context) {
    setState(() {
      OtherPersonScreen.countOtherMessage = countMy;
      MySelfScreen.countMyMessage = 0;
    });
  }

  void permissionCheckAudioAndStorage() async {
    bool isRequestPermission = await requestPermissionForStorageAndMicrophone();
    if (isRequestPermission) {
      _start();
    }
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        Directory appDocDirectory;
        if (Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);

        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var result = await _recorder.stop();
    _insertOtherPersonLocalSaved(
        dataFileSaveInLocal: result.path,
        durationRecordTime: result.duration.toString());
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

}
