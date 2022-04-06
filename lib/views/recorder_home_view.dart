import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:task/controller/file_recorder_controller.dart';
import 'package:task/views/file_view.dart';
import 'package:task/views/recorded_file_view.dart';

class RecorderHomeView extends StatefulWidget {
  const RecorderHomeView({Key? key}) : super(key: key);

  @override
  _RecorderHomeViewState createState() => _RecorderHomeViewState();
}

class _RecorderHomeViewState extends State<RecorderHomeView> {
  @override
  void initState() {
    super.initState();
    var fileRecordProvider =
        Provider.of<FileRecorderController>(context, listen: false);
    getApplicationDocumentsDirectory().then((value) {
      fileRecordProvider.appDirectory = value;
    });
  }

  @override
  void dispose() {
    var fileRecordProvider =
        Provider.of<FileRecorderController>(context, listen: false);
    fileRecordProvider.appDirectory.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Task',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            RecordFileView(),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.green,
              thickness: 1,
              endIndent: 50,
              indent: 50,
            ),
            SizedBox(
              height: 20,
            ),
            FileView(),
            Spacer(),
            TextButton(
              onPressed: () async {
                var fileRecordProvider = Provider.of<FileRecorderController>(context, listen: false);
                await fileRecordProvider.sendFiles();

              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.teal, padding: EdgeInsets.all(10)),
              child: Text(
                'Send Files',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
