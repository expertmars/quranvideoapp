import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranvideo/provider/utils.dart';
import 'package:quranvideo/widgets/audio_trimmer.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  // String? fileName;
  String? path;

  @override
  Widget build(BuildContext context) {
    path = context.read<Utils>().audioPath;
    return Column(
      children: [
        if (path != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  path?.split('/').last ?? 'No File selected',
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              CloseButton(onPressed: () {
                setState(() {
                  context.read<Utils>().setAudioPath(null);
                });
              })
            ],
          ),
          Text(
            'You have ${context.read<Utils>().ayahs.length - 1} split(s) to mark the ending',
            textAlign: TextAlign.center,
          ),
          if (path != null) AudioTrimmer(filePath: path!),
        ],
        if (path == null) ...[
          Container(
              child: ElevatedButton(
            child: Text('Pick Audio'),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                File file = File(result.files.single.path!);
                setState(() {
                  context.read<Utils>().setAudioPath(file.path);
                });
              } else {
                // User canceled the picker
              }
            },
          )),
          Container(
              child: ElevatedButton(
            child: Text('Video Audio'),
            onPressed: () async {
              setState(() {
                final utils = context.read<Utils>();
                utils.setAudioPath(utils.videoPath);
              });
            },
          )),
        ]
        // Container(
        //     child: CheckboxListTile(
        //   value: true,
        //   title: Text('Use Video Audio'),
        //   onChanged: (va) {
        //     if (va == true) {
        //       setState(() {
        //         path = context.read<Utils>().videoPath;
        //         fileName = path!.split('/').last;
        //       });
        //     }
        //   },
        // )),
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
