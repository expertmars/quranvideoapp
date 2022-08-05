import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quranvideo/provider/utils.dart';
import 'package:share_plus/share_plus.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key? key}) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  @override
  void initState() {
    super.initState();
    // _hasAcceptedPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final p = (context.watch<Utils>().perc * 100);
    return Container(
      child: Column(
        children: [
          if ((p != 100)) ...[
            Text('${p.toStringAsFixed(0)}%', style: TextStyle(fontSize: 32)),
            LinearProgressIndicator(
              value: context.watch<Utils>().perc,
            ),
          ],
          SizedBox(
            height: 20,
          ),
          if ((p == 100))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final dir = context.read<Utils>().albumStoragePath;
                    final id = context.read<Utils>().projectId;
                    OpenFile.open("$dir/QuranVideoMaker/$id.mp4");
                  },
                  child: Text('Play'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final dir = context.read<Utils>().albumStoragePath;
                    final id = context.read<Utils>().projectId;

                    Share.shareFiles(["$dir/QuranVideoMaker/$id.mp4"],
                        text: 'Made with FreeQuranVideoMaker');
                  },
                  child: Text('Share'),
                  style: ElevatedButton.styleFrom(primary: Colors.purple),
                ),
              ],
            )
        ],
      ),
    );
  }

  videoItem() {
    return Container(
        child: Column(
      children: [
        Image(image: AssetImage('assets/trans.jpg')),
        SizedBox(
          height: 15,
        ),
        Text(
          'filename',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    ));
  }
}
