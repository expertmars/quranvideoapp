import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranvideo/pages/audio_screen.dart';
import 'package:quranvideo/pages/surah_screen.dart';
import 'package:quranvideo/pages/timeline_screen.dart';
import 'package:quranvideo/pages/video_screen.dart';
import 'package:quranvideo/provider/utils.dart';

void main() {
  runApp(const MyApp());
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
          ),
          // trackShape: CustomTrackShape()),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentStep = 0;

  int surah = 1;
  int ayahStart = 1;
  int ayahEnd = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Stepper(
          currentStep: currentStep,
          steps: getSteps(),
          onStepContinue: () => setState(() {
            int lastStep = getSteps().length - 1;
            if (currentStep == lastStep) return;
            currentStep = currentStep + 1;
          }),
          onStepCancel: () => setState(() {
            if (currentStep == 0) return;
            currentStep = currentStep - 1;
          }),
        ));
  }

  List<Step> getSteps() {
    return [
      Step(
        title: Text('Surah Details'),
        content: SurahScreen(),
      ),
      Step(title: Text('Audio'), content: AudioScreen()),
      Step(title: Text('Video'), content: VideoScreen()),
      Step(title: Text('Timeline'), content: TimelineScreen())
    ];
  }
}
