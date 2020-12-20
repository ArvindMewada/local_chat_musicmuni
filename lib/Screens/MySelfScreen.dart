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
  final dbHelperOtherPerson = DatabaseHelperOtherPerson.instanceOtherPeron;
  final mySelfController = TextEditingController();
  bool isMicShow = true;

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  @override
  initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    mySelfController.dispose();
    _recorder.stop();
    _currentStatus = RecordingStatus.Unset;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Self'),
        elevation: 8,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("My Self"),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 45,
                child: TextField(
                  controller: mySelfController,
                ),
              ),
              FlatButton(
                onPressed: () {
                  // _insert(); // insert data to other data base
                  permissionCheck();
                  HapticFeedback.vibrate();
                },
                color: Colors.lightBlue,
                child: Text(
                  "Start",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              new FlatButton(
                onPressed:
                    _currentStatus != RecordingStatus.Unset ? _stop : null,
                child: new Text("Stop", style: TextStyle(color: Colors.black)),
                color: Colors.blueAccent.withOpacity(0.5),
              ),
              SizedBox(
                width: 8,
              ),
              new FlatButton(
                onPressed: () {
                  onPlayAudio();
                },
                child: new Text("Play", style: TextStyle(color: Colors.black)),
                color: Colors.blueAccent.withOpacity(0.5),
              ),
              new Text("File path of the record: ${_current?.path}"),
              new Text(
                  "Audio recording duration : ${_current?.duration.toString()}")
            ],
          ),
        ),
      ),
    );
  }

  void permissionCheck() async {
    bool isRequestPermission = await requestPermissionForStorageAndMicrophone();
    if (isRequestPermission) {
      switch (_currentStatus) {
        case RecordingStatus.Initialized:
          {
            _start();
            break;
          }
        case RecordingStatus.Recording:
          {
            _stop();
            break;
          }
        default:
          break;
      }
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
    _insertOtherPersonLocalSaved(result.path);
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
    int a = await dbHelperOtherPerson.getCountOtherMessage();
    setState(() {
      Home.countOtherMessage = a;
    });
  }

  void _insertOtherPersonLocalSaved(String fileString) async {
    // row to insert
    OtherPersonDataModel otherPersonDataModel = OtherPersonDataModel();
    otherPersonDataModel.id = DateTime.now().millisecondsSinceEpoch;
    if (fileString != null && fileString.toString().length > 0) {
      otherPersonDataModel.data = fileString;
    } else {
      otherPersonDataModel.data = mySelfController.text.toString();
    }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('h:mm a').format(now);
    otherPersonDataModel.time = formattedDate;
    await dbHelperOtherPerson.createOtherPersonDB(otherPersonDataModel.toMap());
    // await dbHelperOtherPerson.newRowInsertExistingTableInOtherPerson(otherPersonDataModel);
    getCountOtherMessage(context);
  }
}
