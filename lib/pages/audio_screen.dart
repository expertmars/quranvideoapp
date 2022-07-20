import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quranvideo/widgets/audio_player.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  String? fileName;
  String? path;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (fileName != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(fileName!),
              CloseButton(onPressed: () {
                setState(() {
                  fileName = null;
                });
              })
            ],
          ),
          AudioTrimmer(filePath: path!),
        ],
        if (fileName == null)
          Container(
              child: ElevatedButton(
            child: Text('Pick Audio'),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                File file = File(result.files.single.path!);
                setState(() {
                  fileName = file.path.split('/').last;
                  path = file.path;
                });
              } else {
                // User canceled the picker
              }
            },
          )),
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
