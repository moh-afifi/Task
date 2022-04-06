import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/controller/file_recorder_controller.dart';
import 'package:task/helpers/reusable_option_card.dart';

class FileView extends StatefulWidget {
  const FileView({Key? key}) : super(key: key);

  @override
  _FileViewState createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FileRecorderController>(
      builder: (context, myProvider, child) {
        return Column(
          children: [
            ReusableOptionCard(
              icon: Icons.attach_file_outlined,
              text: 'Pick a File',
              onTap: () async {
                await myProvider.pickFile();
              },
              iconColor: Colors.black,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              (myProvider.file != null) ? 'File Name: ${basename(myProvider.file!.path)}' : '',
            )
          ],
        );
      },
    );
  }
}
