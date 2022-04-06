import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/controller/file_recorder_controller.dart';
import 'package:task/helpers/reusable_option_card.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';

class RecordFileView extends StatefulWidget {
  final String recordPath;
  final Function onSaved;

  const RecordFileView({
    Key? key,
    required this.recordPath,
    required this.onSaved,
  }) : super(key: key);

  @override
  _RecordFileViewState createState() => _RecordFileViewState();
}

class _RecordFileViewState extends State<RecordFileView> {
  @override
  void initState() {
    super.initState();
    var fileRecordProvider = Provider.of<FileRecorderController>(context, listen: false);
    FlutterAudioRecorder2.hasPermissions.then((hasPermission) {
      if (hasPermission!) {
        fileRecordProvider.recordingState = RecordingState.Set;
        fileRecordProvider.recordIcon = Icons.mic;
        fileRecordProvider.recordText = 'Record';
      }
    });
  }

  @override
  void dispose() {
    var fileRecordProvider = Provider.of<FileRecorderController>(context, listen: false);
    fileRecordProvider.recordingState = RecordingState.UnSet;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FileRecorderController>(
      builder: (context, myProvider, child) {
        return Column(
          children: [
            ReusableOptionCard(
              icon: myProvider.recordIcon,
              text: myProvider.recordText,
              onTap: () async {
                await myProvider.onRecordButtonPressed(widget.onSaved, context);
                setState(() {});
              },
              iconColor: myProvider.iconColor,
            ),
            SizedBox(
              height: 20,
            ),
            widget.recordPath.isEmpty
                ? Center(child: Text('No records yet'))
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: ExpansionTile(
                      title: Text('Your Record'),
                      subtitle: Text(myProvider.getDateFromFilePath(filePath: widget.recordPath)),
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LinearProgressIndicator(
                              minHeight: 8,
                              backgroundColor: Colors.black,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.teal),
                              value: myProvider.completedPercentage,
                            ),
                            IconButton(
                              icon: myProvider.isPlaying
                                  ? Icon(Icons.play_arrow_outlined,
                                      size: 40, color: Colors.orange)
                                  : Icon(
                                      Icons.play_circle_fill_outlined,
                                      size: 40,
                                      color: Colors.teal,
                                    ),
                              onPressed: () => myProvider.onPlay(
                                  filePath: widget.recordPath),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
          ],
        );
      },
    );
  }
}
