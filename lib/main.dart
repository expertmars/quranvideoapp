import 'dart:async';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quranvideo/pages/audio_screen.dart';
import 'package:quranvideo/pages/ayaheditor_screen.dart';
import 'package:quranvideo/pages/export_screen.dart';
import 'package:quranvideo/pages/landing_screen.dart';
import 'package:quranvideo/pages/surah_screen.dart';
import 'package:quranvideo/pages/preview_screen.dart';
import 'package:quranvideo/pages/video_screen.dart';
import 'package:quranvideo/provider/subt.dart';
import 'package:quranvideo/provider/utils.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Utils>(
      create: (context) => Utils(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          sliderTheme: SliderThemeData(
            overlayShape: SliderComponentShape.noThumb,
            trackShape: CustomTrackShape(),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
        ),
        home: const LandingScreen(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isLoadProject;
  const HomePage({this.isLoadProject = false, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Steps {
  surahDetails,
  ayahEditor,
  video,
  audio,
  preview,
  export,
}

class _HomePageState extends State<HomePage> {
  int currentStep = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isLoadProject) {
      setState(() {
        currentStep = 1;
      });
    } else {
      context.read<Utils>().createNewProj();
    }
  }

  startLoading() {
    setState(() {
      loading = true;
    });
  }

  stopLoading() {
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Home'), actions: [
          // IconButton(
          //   icon: Icon(Icons.start),
          //   onPressed: () {
          //     context.read<Utils>().loadProject('1659635554435', context);
          //   },
          // ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              context.read<Utils>().saveProject();
            },
          ),
        ]),
        body: Stack(
          children: [
            Stepper(
              currentStep: currentStep,
              steps: getSteps(),
              onStepContinue: () async {
                int lastStep = getSteps().length - 1;
                if (currentStep == lastStep) return;
                //  IF NEXT SCREEN IS AYAH EDITOR SCREEN
                if (currentStep == Steps.surahDetails.index) {
                  startLoading();
                  await context.read<Utils>().fetchSurahInfo();
                  await context.read<Utils>().downloadFonts();
                  stopLoading();
                }
                //  IF NEXT SCREEN IS AUDIO EDITOR SCREEN - check a valid video is selected
                if (currentStep == Steps.video.index) {
                  if (context.read<Utils>().videoPath == null) {
                    Fluttertoast.showToast(msg: 'Select a video to continue');
                    return;
                  }
                }
                if (currentStep == Steps.audio.index) {
                  if (context.read<Utils>().audioPath == null) {
                    Fluttertoast.showToast(msg: 'Select a audio to continue');
                    return;
                  }
                }
                if (currentStep == Steps.audio.index) {
                  if (context.read<Utils>().findNextAyahNeedEndingTime() !=
                      null) {
                    Fluttertoast.showToast(
                        msg: 'Pending to mark the ayah ending time');
                    return;
                  }
                  startLoading();
                  await context.read<Utils>().controller?.pause();
                  await context.read<Utils>().player?.pause();
                  print('PREVIEW');
                  await saveSubtitleFile(context);
                  await context.read<Utils>().loadFonts();
                  await context.read<Utils>().generateVideo(preview: true);
                  stopLoading();
                }
                //  IF NEXT SCREEN IS TIMELINE
                if (currentStep == Steps.preview.index) {
                  print('EXPOTR');
                  startLoading();
                  await context.read<Utils>().generateVideo(preview: false);
                  await context.read<Utils>().controller!.pause();
                  stopLoading();
                  // await context.read<Utils>().controller!.dispose();
                  // await context.read<Utils>().generatePreview();
                }
                // ...
                setState(() {
                  currentStep = currentStep + 1;
                });
              },
              onStepCancel: () async {
                if (currentStep == 0) return;

                if (currentStep == Steps.preview.index) {
                  print('PREVIEW SCREEN');
                  Future.delayed(Duration(milliseconds: 500), () {
                    context.read<Utils>().controller?.pause();
                  });
                  if (context.read<Utils>().activeSession != null) {
                    FFmpegKit.cancel();
                  }
                }

                if (currentStep == Steps.export.index) {
                  print('EXPORT SCREEN');
                  context.read<Utils>().playVideo();

                  if (context.read<Utils>().activeSession != null) {
                    FFmpegKit.cancel();
                  }
                }

                if (currentStep == Steps.audio.index) {
                  print('leaving aduio screen');
                  await context.read<Utils>().player?.pause();
                }

                setState(() {
                  currentStep = currentStep - 1;
                });
              },
            ),
            if (loading)
              Container(
                color: Colors.black.withOpacity(.5),
                width: double.infinity,
                child: Center(
                    child: Container(
                        padding: EdgeInsets.all(20),
                        // width: 200,
                        // height: 200,
                        decoration: const BoxDecoration(
                            // color: Colors.white,
                            ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircularProgressIndicator(
                              // backgroundColor: Colors.black,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text('LOADING',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ))
                          ],
                        ))),
              ),
          ],
        ));
  }

  getState(int stepId) {
    if (currentStep == stepId) return StepState.indexed;
    if (currentStep < stepId) return StepState.disabled;
    return currentStep >= stepId ? StepState.complete : StepState.indexed;
  }

  List<Step> getSteps() {
    return [
      Step(
        title: Text('Surah Details'),
        content: SurahScreen(),
        isActive: currentStep >= 0,
        state: getState(0),
      ),
      Step(
        title: Text('Ayah Editor'),
        content: AyahEditorScreen(),
        isActive: currentStep >= 1,
        state: getState(2),
      ),
      Step(
        title: Text('Video'),
        content: VideoScreen(),
        isActive: currentStep >= 2,
        state: getState(2),
      ),
      Step(
        title: Text('Audio'),
        content: AudioScreen(),
        isActive: currentStep >= 3,
        state: getState(3),
      ),
      Step(
        title: Text('Preview'),
        content: PreviewScreen(),
        isActive: currentStep >= 4,
        state: getState(4),
      ),
      Step(
        title: Text('Export'),
        content: ExportScreen(),
        isActive: currentStep >= 5,
        state: getState(5),
      )
    ];
  }
}
