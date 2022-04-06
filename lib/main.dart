import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/views/recorder_home_view.dart';

import 'controller/file_recorder_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FileRecorderController>(create: (_) => FileRecorderController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task',
      debugShowCheckedModeBanner: false,
      home: RecorderHomeView(),
    );
  }
}
