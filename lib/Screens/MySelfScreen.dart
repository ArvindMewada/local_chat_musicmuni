import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app_musicmuni_sample/DataBaseProvider/DataBaseHelperOtherPerson.dart';
import 'package:chat_app_musicmuni_sample/DataBaseProvider/OtherPersonDataModel.dart';
import 'package:chat_app_musicmuni_sample/Utils/Util.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../home_widget.dart';

class MySelfScreen extends StatefulWidget {
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
  bool isSendShow = false;

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  @override
  initState() {
    super.initState();
    _init();
    mySelfController.addListener(controlOfInputTextField);
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

  bool fullWidthAudioRecord = false;

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
          : Container(
              margin: EdgeInsets.only(bottom: 30, left: 16),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: Container(
                        margin: EdgeInsets.only(right: 16),
                        padding: EdgeInsets.only(left: 30),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        child: new TextField(
                          showCursor: false,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 10,
                          controller: mySelfController,
                          decoration: new InputDecoration(
                              filled: false,
                              border: InputBorder.none,
                              hintStyle: new TextStyle(color: Colors.grey[500], fontSize: 14),
                              hintText: "Type a message...",
                              fillColor: Colors.white),
                        ),

                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.vibrate();
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
                        child: Container(
                           height: 50,
                            width: 50,
                            child: iconsSendAndRecordWidget(
                                context: context, counter: 2)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new FlatButton(
                onPressed: () {
                  onPlayAudio();
                },
                child:
                new Text("Play", style: TextStyle(color: Colors.black)),
                color: Colors.blueAccent.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
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
            Expanded(
              flex: 1,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
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
            ),
            Expanded(
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
            ),
            Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {
                      // todo stop audio and saved local
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
                    )))),
          ],
        ),
      ),
    );
  }

  Widget iconsSendAndRecordWidget({BuildContext context, int counter}) {
    return Container(
      margin: EdgeInsets.only(right: 25),
      decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.all(Radius.circular(100))),
      child: Center(
        child: isSendShow
            ? Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 25,
              )
            : Icon(
                Icons.mic_none,
                color: Colors.white,
                size: 25,
              ),
      ),
    );
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
    _insertOtherPersonLocalSaved(dataFileSaveInLocal: result.path);
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }

  void getCountOtherMessage(BuildContext context) async {
    int countOtherMessage = await dbHelperOtherPerson.getCountOtherMessage();
    if (countOtherMessage != null) {
      setState(() {
        Home.countOtherMessage = countOtherMessage;
      });
    }
  }

  void _insertOtherPersonLocalSaved({String dataFileSaveInLocal}) async {
    // row to insert
    OtherPersonDataModel otherPersonDataModel = OtherPersonDataModel();
    otherPersonDataModel.id = DateTime.now().millisecondsSinceEpoch;
    if (isSendShow) {
      otherPersonDataModel.data = dataFileSaveInLocal.toString();
    } else {
      otherPersonDataModel.data = dataFileSaveInLocal.toString();
    }

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('h:mm a').format(now);
    otherPersonDataModel.time = formattedDate;
    // await dbHelperOtherPerson.createOtherPersonDB(otherPersonDataModel.toMap());
    // await dbHelperOtherPerson.newRowInsertExistingTableInOtherPerson(otherPersonDataModel);
    getCountOtherMessage(context);
  }
}
