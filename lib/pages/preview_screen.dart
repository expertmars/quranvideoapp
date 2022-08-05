import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:provider/provider.dart';
import 'package:quranvideo/provider/subt.dart';
import 'package:quranvideo/provider/utils.dart';
import 'package:video_player/video_player.dart';

class PreviewScreen extends StatefulWidget {
  PreviewScreen({Key? key}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    final fileList = context.watch<Utils>().fileList;
    log(context.watch<Utils>().asp_ratio.toString());
    return Column(
      children: [
        if (utils.controller != null && utils.controller!.value.isPlaying)
          AspectRatio(
            aspectRatio: context.watch<Utils>().asp_ratio,
            child: VideoPlayer(utils.controller!),
          ),
        if (!(utils.controller?.value.isPlaying ?? false))
          Text('${(context.watch<Utils>().perc * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 32)),
        // if (utils.controller != null && !utils.controller!.value.isPlaying)
        if (!(utils.controller?.value.isPlaying ?? false))
          LinearProgressIndicator(
            value: context.watch<Utils>().perc,
          ),

        // fileList.isEmpty
        //     ? Text('No Images Generated')
        //     : BetterPlayer.file(
        //         context.read<Utils>().extStoragePath + '/preview/output.mp4',
        //         betterPlayerConfiguration: BetterPlayerConfiguration(
        //             looping: true,
        //             aspectRatio: context.watch<Utils>().asp_ratio,
        //             autoPlay: true,
        //             controlsConfiguration:
        //                 const BetterPlayerControlsConfiguration(
        //               showControls: false,
        //             ),
        //             // autoDetectFullscreenAspectRatio: true,
        //             autoDetectFullscreenDeviceOrientation: true,
        //             expandToFill: true),
        //       ),
        // Container(
        //   child: ElevatedButton(
        //     child: Text('Convert'),
        //     onPressed: () async {
        //       setState(() {});
        //     },
        //   ),
        // ),
      ],
    );
  }
}
