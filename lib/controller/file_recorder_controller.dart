import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:task/services/send_files.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';

enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class FileRecorderController extends ChangeNotifier {
  SendFiles _sendFiles = SendFiles();
  bool isPlaying = false;
  late int _totalDuration, _currentDuration;
  double completedPercentage = 0.0;
  IconData recordIcon = Icons.mic_none;
  Color iconColor = Colors.teal;
  String recordText = 'Click To Start',recordPath = '';
  RecordingState recordingState = RecordingState.UnSet;
  late FlutterAudioRecorder2 audioRecorder;
  File? file;
  late Directory appDirectory;
  //----------------------------------------------------
  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path!);
      notifyListeners();
    }
  }

  //----------------------------------------------------
  Future<void> sendFiles() async {
    List<String> filePaths = [];
    filePaths.addAll([file!.path, recordPath]);
    await _sendFiles.sendFiles(filePaths);
  }

  //-------------------------------------------------------------------
  Future<void> onPlay({required String filePath}) async {
    AudioPlayer audioPlayer = AudioPlayer();
    if (!isPlaying) {
      audioPlayer.play(filePath, isLocal: true);
      completedPercentage = 0.0;
      isPlaying = true;
      notifyListeners();

      audioPlayer.onPlayerCompletion.listen((_) {
        isPlaying = false;
        completedPercentage = 0.0;
        notifyListeners();
      });

      audioPlayer.onDurationChanged.listen((duration) {
        _totalDuration = duration.inMicroseconds;
        notifyListeners();
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        _currentDuration = duration.inMicroseconds;
        completedPercentage =
            _currentDuration.toDouble() / _totalDuration.toDouble();
        notifyListeners();
      });
    }
  }

  //-------------------------------------------------------------------
  String getDateFromFilePath({required String filePath}) {
    String fromEpoch = filePath.substring(filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));
    DateTime recordedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;
    return ('$day-$month-$year || ${recordedDate.hour}:${recordedDate.minute}');
  }

  //-------------------------------------------------------------------
  Future<void> onRecordButtonPressed(Function onSaved, BuildContext context) async {
    switch (recordingState) {
      case RecordingState.Set:
        await _recordVoice(context);
        notifyListeners();
        break;

      case RecordingState.Recording:
        await audioRecorder.stop();
        onSaved();
        recordingState = RecordingState.Stopped;
        recordIcon = Icons.fiber_manual_record;
        recordText = 'Record Again';
        iconColor = Colors.teal;
        notifyListeners();
        break;

      case RecordingState.Stopped:
        await _recordVoice(context);
        notifyListeners();
        break;

      case RecordingState.UnSet:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please allow recording from settings.'),
        ));
        break;
    }
  }
  //-------------------------------------------------------------------
  Future<void> _recordVoice(BuildContext context) async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      Directory appDirectory = await getApplicationDocumentsDirectory();
      String filePath = appDirectory.path + '/' + DateTime.now().millisecondsSinceEpoch.toString() + '.aac';
      audioRecorder = FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.AAC);
      await audioRecorder.initialized;
      await audioRecorder.start();
      recordingState = RecordingState.Recording;
      recordIcon = Icons.stop;
      recordText = 'Recording';
      iconColor = Colors.red;
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please allow recording from settings.'),
        ),
      );
    }
  }

  //-------------------------------------------------------------------
  onRecordComplete() {
    List<String> tempRecord = [];
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) tempRecord.add(onData.path);
      notifyListeners();
    }).onDone(() {
      recordPath = tempRecord.last;
      notifyListeners();
    });
  }
  //-------------------------------------------------------------------
}
