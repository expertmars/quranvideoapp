import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:quranvideo/models/ayah.dart';
import 'package:quranvideo/provider/subt.dart';
import 'package:quranvideo/provider/utils.dart';

class AudioTrimmer extends StatefulWidget {
  final String filePath;

  const AudioTrimmer({required this.filePath, Key? key}) : super(key: key);

  @override
  State<AudioTrimmer> createState() => _AudioTrimmerState();
}

class _AudioTrimmerState extends State<AudioTrimmer> {
  late AudioPlayer player;
  late Duration duration = Duration.zero;
  late Duration position = Duration.zero;

  List<Color> colors = [];

  StreamSubscription? posStreamSub;

  loadAudio() async {
    player = AudioPlayer(); // Create a player
    context.read<Utils>().player = player;
    player.setLoopMode(LoopMode.all);

    duration = (await player.setFilePath(widget.filePath) ?? Duration.zero);

    context
        .read<Utils>()
        .setLastAyahEndingTimeToDuration(duration.inMilliseconds);

    colors = List.generate(50,
        (index) => Colors.primaries[Random().nextInt(Colors.primaries.length)]);

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
    final ayahs = context.watch<Utils>().ayahs;
    final nextAyah = context.read<Utils>().findNextAyahNeedEndingTime();

    return Column(children: [
      nextAyah != null
          ? Text(nextAyah.glyph,
              style: TextStyle(fontFamily: nextAyah.fontFamily(), fontSize: 19))
          : Text('done'),
      Slider(
        value: position.inMilliseconds.toDouble(),
        max: duration.inMilliseconds.toDouble(),
        onChanged: (val) {
          setState(() {
            position = Duration(milliseconds: val.toInt());
            player.seek(position);
          });
        },
      ),
      duration == Duration.zero
          ? CircularProgressIndicator()
          : Container(
              color: Colors.grey,
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: ayahs.mapIndexed((i, e) {
                  // need to find the previous ayah ending time to find the starting time of the current ayah.
                  // so that get the correct length of each ayah.

                  int currentTime = 0;
                  if (i != 0) {
                    currentTime = ayahs[i - 1].endingTime ?? 0;
                  }
                  final length = (e.endingTime ?? 0) - currentTime;
                  if (length < 0) {
                    return getAyahRangeIndicator(
                        duration.inMilliseconds, i, colors[i]);
                  }

                  return getAyahRangeIndicator(length, i, colors[i]);

                  // int currentTime = 0;
                  // if (i != 0 && e.endingTime != null) {
                  //   currentTime = ayahs[i - 1].endingTime ?? 0;
                  // }
                  // final length = (e.endingTime ?? 0) - currentTime;
                  // if (length < 0)
                  //   return getAyahRangeIndicator(duration!.inMilliseconds, i);
                  // return getAyahRangeIndicator(length, i);
                }).toList(),
              ),
            ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              position.toString().substring(0, position.toString().length - 4)),
          Text(
              duration.toString().substring(0, duration.toString().length - 4)),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                if (position == duration) {
                  setState(() {
                    position = Duration.zero;
                  });
                }

                player.play();
              }),
          IconButton(
              icon: Icon(Icons.pause),
              onPressed: () {
                print(context.read<Utils>().ayahs[0].endingTime);
                player.pause();
              }),
          IconButton(
              icon: Icon(Icons.track_changes),
              onPressed: () {
                context.read<Utils>().resetSplits(duration.inMilliseconds);
                // context.read<Utils>().clearSpaces();
              }),
          // IconButton(
          //     icon: Icon(Icons.travel_explore),
          //     onPressed: () {
          //       context.read<Utils>().test();
          //       // context.read<Utils>().clearSpaces();
          //     }),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: nextAyah != null
                    ? Border.all(color: Colors.red, width: 1)
                    : null),
            child: GestureDetector(
              child: Icon(Icons.push_pin_rounded),
              onLongPressEnd: (details) {
                if (nextAyah == null) {
                  Fluttertoast.showToast(msg: 'Select an ayah to edit');
                  return print('no more splits there');
                }
                context
                    .read<Utils>()
                    .setEndingTimeOfAyah(nextAyah.id, position.inMilliseconds);
                player.setSpeed(1);
              },
              onLongPressStart: (details) {
                if (nextAyah == null) {
                  Fluttertoast.showToast(msg: 'Select an ayah to edit');
                  return print('no more splits there');
                }
                player.setSpeed(.5);
                // player.pause();

                // context.read<Utils>().setEndingTimeOfAyah(
                //     nextAyah.id, position.inMilliseconds);
              },
              onTap: () {
                if (nextAyah == null) {
                  Fluttertoast.showToast(msg: 'Select an ayah to edit');
                  return print('no more splits there');
                }

                player.pause();

                context
                    .read<Utils>()
                    .setEndingTimeOfAyah(nextAyah.id, position.inMilliseconds);
              },
            ),
          )
        ],
      ),
    ]);
  }

  Widget getAyahRangeIndicator(int endingTimeMilliSec, int index, Color c) {
    final wfactor = endingTimeMilliSec / duration.inMilliseconds;
    return GestureDetector(
      onTap: () {
        // if (index == context.read<Utils>().ayahs.length - 1) return;

        setState(() {
          context.read<Utils>().ayahs[index].setted =
              !context.read<Utils>().ayahs[index].setted;
        });
      },
      child: FractionallySizedBox(
        widthFactor: wfactor >= 0 ? wfactor : 5.5,
        child: Container(
          decoration: BoxDecoration(
            border: !context.read<Utils>().ayahs[index].setted
                ? Border.all(
                    color: Colors.black,
                    width: 1,
                  )
                : null,
            color: c,
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          width: double.infinity,
          child: Text('${index + 1}', style: TextStyle(color: Colors.white)),

          // height: 10,
        ),
      ),
    );
  }
}
