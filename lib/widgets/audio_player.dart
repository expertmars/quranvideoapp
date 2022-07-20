import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioTrimmer extends StatefulWidget {
  final String filePath;

  const AudioTrimmer({required this.filePath, Key? key}) : super(key: key);

  @override
  State<AudioTrimmer> createState() => _AudioTrimmerState();
}

class _AudioTrimmerState extends State<AudioTrimmer> {
  late AudioPlayer player;
  Duration? duration;
  Duration? position;

  StreamSubscription? posStreamSub;

  loadAudio() async {
    player = AudioPlayer(); // Create a player
    duration = await player.setFilePath(widget.filePath);

    posStreamSub = player.positionStream.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadAudio();
  }

  @override
  void dispose() {
    posStreamSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Slider(
        value: position!.inSeconds.toDouble(),
        max: duration!.inSeconds.toDouble(),
        onChanged: (val) {},
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(position.toString()),
          Text('23:00:33'),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                player.play();
              }),
          IconButton(
              icon: Icon(Icons.pause),
              onPressed: () {
                player.pause();
              }),
        ],
      ),
    ]);
  }
}
