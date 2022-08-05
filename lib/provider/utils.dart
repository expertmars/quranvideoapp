import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dynamic_cached_fonts/dynamic_cached_fonts.dart';
import 'package:external_path/external_path.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full/log.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quranvideo/constants/constants.dart';
import 'package:quranvideo/models/ayah.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quranvideo/provider/permission.dart';
import 'package:quranvideo/provider/subt.dart';
import 'package:quranvideo/widgets/color_ext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';

class Utils with ChangeNotifier {
  String projectId = 'unknown';

  Set arabicFontsUsed = {};
  List<Ayah> ayahs = [];
  // List<Ayah> undoAyahs = [];

  late SharedPreferences prefs;

  String? _audioPath;
  String? _videoPath;

  Color _colorBg = Color(0x70000000);

  String? engFontPath;
  String? localFontPath;
  String? localFontFamily;
  String? engFontFamily;

  int _surahNo = 1;
  int _from = 1;
  int _to = 2;
  int engTransId = 203;
  int localTransId = 80;

  double perc = 0.0;
  double asp_ratio = 1;
  int pos_x = 350;
  int pos_y = 500;

  String extStoragePath = '';
  String albumStoragePath = '';

  List<FileSystemEntity> fileList = [];

  int engFontSize = 50;
  int ayahFontSize = 50;
  int localFontSize = 50;

  Color engColor = Color(0xFFFFFFFF);
  Color ayahColor = Color(0xFFFFFFFF);
  Color localColor = Color(0xFFFFFFFF);

  bool ayahEnable = true;
  bool engEnable = true;
  bool localEnable = true;

  VideoPlayerController? controller;
  FFmpegSession? activeSession;
  AudioPlayer? player;

  //SETTERS
  setPlayerSource() async {
    controller =
        VideoPlayerController.file(File(extStoragePath + '/preview/output.mp4'))
          ..initialize().then((value) => notifyListeners());
    controller!.play();
    controller!.setLooping(true);
    controller!.setVolume(0);
  }

  setAudioPath(String? path) {
    _audioPath = path;
  }

  setVideoPath(String path) {
    _videoPath = path;
    notifyListeners();
  }

  setColorBg(Color color) {
    _colorBg = color;
    final hex = color.toHex(leadingHashSign: false);
    prefs.setString(PREFS_bgColor, hex);
    notifyListeners();
  }

  setTo(int val) {
    _to = val;
  }

  setFrom(int val) {
    _from = val;
  }

  setSurahNo(int val) {
    _surahNo = val;
  }

  setXAxis(int val) {
    pos_x = val;
  }

  setYAxis(int val) {
    pos_y = val;
  }

  setFontColor(Color color, EditingType type) {
    final c = color.toHex(leadingHashSign: false);
    // HexColor.fromHex(c);
    // print(c);
    // print(c);
    if (type == EditingType.ayah) {
      ayahColor = color;
      print(color);
      prefs.setString(PREFS_ayahFontColor, c);
    } else if (type == EditingType.eng) {
      engColor = color;
      prefs.setString(PREFS_engFontColor, c);
    } else {
      localColor = color;
      prefs.setString(PREFS_localFontColor, c);
    }
    notifyListeners();
  }

  setFontSize(int size, EditingType type) {
    if (type == EditingType.ayah) {
      ayahFontSize = size;
      print('dd');
      prefs.setInt(PREFS_ayahFontSize, size);
    } else if (type == EditingType.eng) {
      engFontSize = size;
      prefs.setInt(PREFS_engFontSize, size);
    } else {
      localFontSize = size;
      prefs.setInt(PREFS_localFontSize, size);
    }
    notifyListeners();
  }

  setEnable(bool val, EditingType type) {
    if (type == EditingType.ayah) {
      ayahEnable = val;
      prefs.setBool(PREFS_ayahEnable, val);
    } else if (type == EditingType.eng) {
      engEnable = val;
      prefs.setBool(PREFS_engEnable, val);
    } else {
      localEnable = val;
      prefs.setBool(PREFS_localEnable, val);
    }
    notifyListeners();
  }

  //GETTERS

  String? get audioPath => _audioPath;
  String? get videoPath => _videoPath;
  Color? get colorBg => _colorBg;

  int? get surahNo => _surahNo;
  int? get from => _from;
  int? get to => _to;

  bool getEnable(EditingType type) {
    if (type == EditingType.ayah) {
      return ayahEnable;
    } else if (type == EditingType.eng) {
      return engEnable;
    } else {
      return localEnable;
    }
  }

  int getFontSize(EditingType type) {
    if (type == EditingType.ayah) {
      return ayahFontSize;
    } else if (type == EditingType.eng) {
      return engFontSize;
    } else {
      return localFontSize;
    }
  }

  Color getFontColor(EditingType type) {
    if (type == EditingType.ayah) {
      return ayahColor;
    } else if (type == EditingType.eng) {
      return engColor;
    } else {
      return localColor;
    }
  }

  selectFont(EditingType type) async {
    if (type == EditingType.ayah) {
      return Fluttertoast.showToast(msg: 'Cannot change the font');
    }
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['ttf', 'otf']);

    if (result != null) {
      File file = File(result.files.single.path!);

      if (type == EditingType.eng) {
        final fileName = file.path.split('/').last;
        // result.files.single.bytes

        //  await File(filePath).writeAsBytes(
        // buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

        final newFile =
            await file.copy(extStoragePath + '/downloaded/$fileName');
        engFontPath = newFile.path;
        engFontFamily = engFontPath!.split('/').last.split('.')[0];

        prefs.setString(PREFS_engFontPath, engFontPath!);
      } else if (type == EditingType.local) {
        final fileName = file.path.split('/').last;
        final newFile =
            await file.copy(extStoragePath + '/downloaded/$fileName');
        localFontPath = newFile.path;
        localFontFamily = localFontPath!.split('/').last.split('.')[0];

        prefs.setString(PREFS_localFontPath, localFontPath!);
      } else {
        print('cannot change the font');
      }
      notifyListeners();
    } else {
      // User canceled the picker
    }
  }

  init({bool isLoadProject = false}) async {
    if (!isLoadProject) {
      projectId = DateTime.now().millisecondsSinceEpoch.toString();
    }

    extStoragePath = (await getExternalStorageDirectory())!.path;
    await hasAcceptedPermissions();
    try {
      albumStoragePath = (await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_MOVIES));
    } catch (e) {
      print(e);
    }
    prefs = await SharedPreferences.getInstance();

    final downloadDir = Directory(extStoragePath + '/downloaded');
    if (await downloadDir.exists()) {
      await downloadDir.create();
    }

    if (!File(extStoragePath + '/downloaded/logo.png').existsSync()) {
      await getFontFileFromAssets('logo.png', notFont: true);
    }

    // Load from prefs
    if (prefs.containsKey(PREFS_localFontPath)) {
      final localfont = prefs.getString(PREFS_localFontPath);
      if (!File(localfont!).existsSync()) {
        localFontPath =
            (await getFontFileFromAssets('Noto Sans Malayalam.ttf')).path;
      } else {
        localFontPath = localfont;
      }
    } else {
      localFontPath =
          (await getFontFileFromAssets('Noto Sans Malayalam.ttf')).path;
    }
    if (prefs.containsKey(PREFS_engFontPath)) {
      final engfont = prefs.getString(PREFS_engFontPath);
      if (!File(engfont!).existsSync()) {
        engFontPath = (await getFontFileFromAssets('Poppins.ttf')).path;
      } else {
        engFontPath = engfont;
      }
    } else {
      engFontPath = (await getFontFileFromAssets('Poppins.ttf')).path;
    }

    if (prefs.containsKey(PREFS_ayahFontSize)) {
      ayahFontSize = prefs.getInt(PREFS_ayahFontSize) ?? 30;
    }
    if (prefs.containsKey(PREFS_engFontSize)) {
      engFontSize = prefs.getInt(PREFS_engFontSize) ?? 30;
    }
    if (prefs.containsKey(PREFS_localFontSize)) {
      localFontSize = prefs.getInt(PREFS_localFontSize) ?? 30;
    }
    //==============
    localFontFamily = localFontPath!.split('/').last.split('.')[0];
    engFontFamily = engFontPath!.split('/').last.split('.')[0];
    //==============

    // load Colors
    if (prefs.containsKey(PREFS_ayahFontColor)) {
      final hexCode = prefs.getString(PREFS_ayahFontColor) ?? 'FFFFFFFF';
      ayahColor = HexColor.fromHex(hexCode);
    }
    if (prefs.containsKey(PREFS_localFontColor)) {
      final hexCode = prefs.getString(PREFS_localFontColor) ?? 'FFFFFFFF';
      localColor = HexColor.fromHex(hexCode);
    }
    if (prefs.containsKey(PREFS_engFontColor)) {
      final hexCode = prefs.getString(PREFS_engFontColor) ?? 'FFFFFFFF';
      engColor = HexColor.fromHex(hexCode);
    }
    //bg color
    if (prefs.containsKey(PREFS_bgColor)) {
      final hexCode = prefs.getString(PREFS_bgColor) ?? 'FF000000';
      _colorBg = HexColor.fromHex(hexCode);
    }
    //load enables
    if (prefs.containsKey(PREFS_ayahEnable)) {
      ayahEnable = prefs.getBool(PREFS_ayahEnable) ?? true;
    }
    if (prefs.containsKey(PREFS_engEnable)) {
      engEnable = prefs.getBool(PREFS_engEnable) ?? true;
    }
    if (prefs.containsKey(PREFS_localEnable)) {
      localEnable = prefs.getBool(PREFS_localEnable) ?? true;
    }

    notifyListeners();
  }

  Future<File> getFontFileFromAssets(String fileName,
      {bool notFont = false}) async {
    ByteData byteData;
    if (notFont) {
      byteData = await rootBundle.load('assets/$fileName');
    } else {
      byteData = await rootBundle.load('assets/fonts/$fileName');
    }
    final buffer = byteData.buffer;
    var filePath = extStoragePath +
        '/downloaded/$fileName'; // file_01.tmp is dump file, can be anything
    if (!await File(filePath).exists()) {
      File(filePath).createSync(recursive: true);
    }
    final f = await File(filePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return f;
  }

  resetToDefaultFont(EditingType type) async {
    if (type == EditingType.local) {
      localFontPath =
          (await getFontFileFromAssets('Noto Sans Malayalam.ttf')).path;
      localFontFamily = fontFamilyFromPath(localFontPath!);
      prefs.remove(PREFS_localFontPath);
    } else if (type == EditingType.eng) {
      engFontPath = (await getFontFileFromAssets('Poppins.ttf')).path;
      engFontFamily = fontFamilyFromPath(engFontPath!);

      prefs.remove(PREFS_engFontPath);
    } else {
      print('nothing toreset here');
    }
    notifyListeners();
  }

  String fontFamilyFromPath(String path) {
    return path.split('/').last.split('.')[0];
  }

  fetchSurahInfo() async {
    ayahs = [];
    //getting ready
    // await init();

    await fetchAyahs();
    await fetchTranslation(
        translationId: localTransId, engTranslationId: engTransId);
    ayahs.forEach((element) => print(element));
  }

  Future fetchAyahs() async {
    for (int i = _from; i <= _to; i++) {
      final verseKey = surahNo.toString() + ":" + i.toString();

      final url =
          'https://api.quran.com/api/v4/quran/verses/code_v2?chapter_number=$surahNo&verse_key=$verseKey';
      final res = await http.get(Uri.parse(url));
      // print(res.body);

      final data = json.decode(res.body);

      final glyph = data["verses"][0]['code_v2'];
      final page = data["verses"][0]['v2_page'];

      final ayah = Ayah(
          id: DateTime.now().toString(),
          glyph: glyph,
          number: i,
          surah: _surahNo,
          pageno: page);
      ayahs.add(ayah);
    }
  }

  Future fetchTranslation(
      {required int translationId,
      required int engTranslationId,
      String? transListName,
      bool convertFML = false}) async {
    print("fetching translations");

    for (var ayah in ayahs) {
      final vkey = ayah.surah.toString() + ':' + ayah.number.toString();
      final url =
          'https://api.quran.com/api/v4/quran/translations/$translationId?verse_key=$vkey';

      final res = await http.get(Uri.parse(url));
      Map<String, dynamic> data = json.decode(res.body);

      final localtrans = data['translations'][0]['text'];
      ayah.local = localtrans;
      // console.log(convertToFML(response.data["translations"][0].text).replace('\n', '\​n'));

      // transListName.push(
      //   convertFML //\n§Ä¡v \n§fpsS aXw. F\n¡v F³sd aXhpw.
      //     ? convertToFML(response.data["translations"][0].text)
      //         .replace(/\\n/g, "\\​n")
      //         .replace(/{/g, "\\{")
      //         .replace(/³sd/g, "sâ")
      //     : response.data["translations"][0].text
      // );

    }

    // Fetching english translations

    for (var ayah in ayahs) {
      final vkey = ayah.surah.toString() + ':' + ayah.number.toString();
      final url =
          'https://api.quran.com/api/v4/quran/translations/$engTranslationId?verse_key=$vkey';

      final res = await http.get(Uri.parse(url));
      Map<String, dynamic> data = json.decode(res.body);

      final engTrans = data['translations'][0]['text'];
      ayah.eng = engTrans;
    }
  }

  delAyah(String ayahId) {
    final index = ayahIndexById(ayahId);
    ayahs.removeAt(index);
    notifyListeners();
  }

  splitAyah(EditingType type, String ayahId, int cursorPos) {
    final ayahIndex = ayahs.indexWhere((ayah) => ayah.id == ayahId);
    final selectedAyah = ayahs[ayahIndex];
    String target;
    if (type == EditingType.ayah) {
      target = selectedAyah.glyph;
    } else if (type == EditingType.eng) {
      target = selectedAyah.eng!;
    } else {
      target = selectedAyah.local!;
    }

    if (cursorPos <= 0 || cursorPos >= target.length) return;
    // prepare the text
    final first = target.substring(0, cursorPos);
    final second = target.substring(cursorPos, target.length);

    // prepare and insert new ayah object
    Ayah firstAyah;
    Ayah secondAyah;
    if (type == EditingType.ayah) {
      firstAyah = selectedAyah.copyWith(glyph: first);
      secondAyah =
          selectedAyah.copyWith(id: DateTime.now().toString(), glyph: second);
    } else if (type == EditingType.eng) {
      firstAyah = selectedAyah.copyWith(eng: first);
      secondAyah =
          selectedAyah.copyWith(id: DateTime.now().toString(), eng: second);
    } else {
      firstAyah = selectedAyah.copyWith(local: first);
      secondAyah =
          selectedAyah.copyWith(id: DateTime.now().toString(), local: second);
    }
    print(first);
    print(second);
    ayahs[ayahIndex] = firstAyah;
    ayahs.insert(ayahIndex + 1, secondAyah);

    showAyahs();
    notifyListeners();
  }

  resetSplits(int durationMilli) {
    ayahs.forEachIndexed((i, element) {
      element.endingTime = durationMilli;
      if (i != ayahs.length - 1) {
        element.setted = false;
      }
    });
    notifyListeners();
  }

  updateTranslation(String ayahId, EditingType type, String val) {
    final ayahIndex = ayahs.indexWhere((ayah) => ayah.id == ayahId);
    final selectedAyah = ayahs[ayahIndex];

    // prepare and insert new ayah object
    if (type == EditingType.eng) {
      ayahs[ayahIndex] = selectedAyah.copyWith(eng: val);
    }
    if (type == EditingType.local) {
      ayahs[ayahIndex] = selectedAyah.copyWith(local: val);
    }
    if (type == EditingType.ayah) {
      ayahs[ayahIndex] = selectedAyah.copyWith(glyph: val);
    }

    // notifyListeners();
  }

  showAyahs() {
    ayahs.forEach((element) {
      print(element);
    });
  }

  createNewProj() async {
    await init();
  }

  clearProjectData() {
    projectId = 'unknown';
    _videoPath = null;
    _audioPath = null;
    ayahs = [];
    notifyListeners();
  }

  Future loadProject(String project, BuildContext context) async {
    await init(isLoadProject: true);
    projectId = project;

    final projectDir = Directory(extStoragePath + '/projects/$projectId');
    // final fontsDir = Directory(projectDir.path + '/fonts');
    // final mediaDir = Directory(projectDir.path + '/media');
    final projectFile = File(projectDir.path + '/settings.json');
    print(projectFile.path);
    if (projectFile.existsSync()) {
      final settingString = await projectFile.readAsString();

      Map<String, dynamic> settings = json.decode(settingString);

      List<dynamic> loadedayahs = settings['ayahs'];
      List<Ayah> convertedayahs = [];

      loadedayahs.forEach((element) {
        Map<String, dynamic> ayahMap = json.decode(element);
        convertedayahs.add(Ayah.fromMap(ayahMap));
        print(element);
      });

      projectId = projectId;
      _colorBg = HexColor.fromHex(settings['bgColor'] ?? '#000000');
      pos_x = settings['posX'] ?? 300;
      pos_y = settings['posY'] ?? 500;
      _videoPath = settings['videoPath'];
      ayahEnable = settings['ayahEnable'];
      engEnable = settings['engEnable'];
      localEnable = settings['localEnable'];
      ayahColor = HexColor.fromHex(settings['ayahColor'] ?? '#000000');
      engColor = HexColor.fromHex(settings['engColor'] ?? '#000000');
      localColor = HexColor.fromHex(settings['localColor'] ?? '#000000');
      ayahFontSize = settings['ayahSize'] ?? 50;
      engFontSize = settings['engSize'] ?? 50;
      localFontSize = settings['localSize'] ?? 60;
      engFontPath = settings['engFont'];
      engFontFamily = settings['engFontFam'];
      localFontPath = settings['localFont'];
      localFontFamily = settings['localFontFam'];
      _audioPath = settings['audioPath'];
      ayahs = convertedayahs;

      await downloadFonts();

      notifyListeners();
      print(projectId);
    } else {
      print('no exits');
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => HomePage(
              isLoadProject: true,
            )));
  }

  saveProject() async {
    final projectDir = Directory(extStoragePath + '/projects/$projectId');
    final fontsDir = Directory(projectDir.path + '/fonts');
    final mediaDir = Directory(projectDir.path + '/media');
    final projectFile = File(projectDir.path + '/settings.json');

    if (!projectDir.existsSync()) {
      projectDir.create(recursive: true);
    }
    if (!fontsDir.existsSync()) {
      fontsDir.createSync(recursive: true);
    }
    if (!mediaDir.existsSync()) {
      mediaDir.createSync(recursive: true);
    }

    // List<String> everyAyahs = [];
    // ayahs.forEach((element) {
    //   everyAyahs.add(element.toJson());
    // });

    // final ayahsString = json.encode(everyAyahs);
    if (localFontPath != null) {
      localFontPath = (await File(localFontPath!)
              .copy(fontsDir.path + '/$localFontFamily.ttf'))
          .path;
    }
    if (engFontPath != null) {
      engFontPath =
          (await File(engFontPath!).copy(fontsDir.path + '/$engFontFamily.ttf'))
              .path;
    }

    // if (audioPath != null) {
    //   final filename = audioPath!.split('/').last;
    //   setAudioPath(
    //       (await File(audioPath!).copy(mediaDir.path + '/$filename')).path);
    // }

    // if (videoPath != null) {
    //   final filename = videoPath!.split('/').last;
    //   setVideoPath(
    //       (await File(videoPath!).copy(mediaDir.path + '/$filename')).path);
    // }

    Map<String, dynamic> settings = {
      'bgColor': _colorBg.toHex(),
      'posX': pos_x,
      'posY': pos_y,
      'videoPath': videoPath,
      'ayahEnable': ayahEnable,
      'engEnable': engEnable,
      'localEnable': localEnable,
      'ayahColor': ayahColor.toHex(),
      'engColor': engColor.toHex(),
      'localColor': localColor.toHex(),
      'ayahSize': ayahFontSize,
      'engSize': engFontSize,
      'localSize': localFontSize,
      'engFont': engFontPath,
      'engFontFam': engFontFamily,
      'localFont': localFontPath,
      'localFontFam': localFontFamily,
      'audioPath': audioPath,
      'ayahs': ayahs,
    };
    final settingString = json.encode(settings);
    await projectFile.create(recursive: true);
    await projectFile.writeAsString(settingString);
  }

  Ayah ayahById(String ayahId) {
    return ayahs.firstWhere((element) => element.id == ayahId);
  }

  int ayahIndexById(String ayahId) {
    return ayahs.indexWhere((element) => element.id == ayahId);
  }

  Ayah? findNextAyahNeedEndingTime() {
    return ayahs.firstWhereOrNull((element) => !element.setted);
  }

  setLastAyahEndingTimeToDuration(int endingMilliSeconds) {
    // for (var i = 0; i < ayahs.length; i++) {
    //   ayahs[i].endingTime = endingMilliSeconds;
    //   if (i == ayahs.length - 1) ayahs[i].setted = true;
    // }
    // notifyListeners();
    ayahs.last =
        ayahs.last.copyWith(endingTime: endingMilliSeconds, setted: true);
    notifyListeners();
  }

  setEndingTimeOfAyah(String ayahId, int endingMilliSecond) {
    final index = ayahIndexById(ayahId);
    final selectedAyah = ayahs[index];
    ayahs[index] =
        selectedAyah.copyWith(endingTime: endingMilliSecond, setted: true);

    notifyListeners();
  }

  test() {
    print(controller!.value.isPlaying);
    print(activeSession);
  }

  playVideo() {
    controller?.play();
    notifyListeners();
  }

  generateVideo({bool preview = false}) async {
    final path = await getExternalStorageDirectory();

    final v = videoPath;
    final a = audioPath;
    String o = path!.path + '/out.mp4';
    final ass = path.path + '/subt.ass';
    final fontsdir = path.path + '/v2';
    final logo = path.path + '/downloaded/logo.png';

    if (preview) {
      o = path.path + '/preview/output.mp4';
      final dir = Directory(path.path + '/preview/');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
    }

    bool useVidAudio = false;

    if (a == v) {
      useVidAudio = true;
    }

    final session = await FFprobeKit.getMediaInformation(v!);
    final information = session.getMediaInformation()!;

    int total = double.parse(information.getDuration()!).toInt();

    if (v != a) {
      final session = await FFprobeKit.getMediaInformation(a!);
      final information = session.getMediaInformation()!;

      final audiototal = double.parse(information.getDuration()!).toInt();
      if (audiototal > total) {
        total = audiototal;
      }
    }

    if (preview) {
      total = 2;
    }
    final width = information.getStreams()[0].getWidth();
    final height = information.getStreams()[0].getHeight();
    if (width != null && height != null) {
      asp_ratio = width / height;
      notifyListeners();
    }
    String calcHeight = 'w=oh*mdar:h=ih/45';
    if (height != null && width != null && height > width) {
      calcHeight = 'w=oh*mdar:h=iw/45';
    }
    // print(information.getAllProperties());

    activeSession = await FFmpegKit.executeAsync(
      // '-i $v -filter_complex "drawtext=fontsize=20:fontcolor=white:fontfile=$font:text=hello" $o',
      // '-i $v -filter_complex "ass=$ass:fontsdir=$fontsdir" -c:a copy -y $o',
      // '-i $v -i $a -filter_complex "ass=$ass: fontsdir=$fontsdir" -c:a copy -y $o',
      '-i $v -f lavfi -i "color=0x${_colorBg.toHexinRGB(leadingHashSign: false)}" -i $logo -filter_complex "[1:v][0:v]scale2ref[1v][0v], [1v]format=rgba,colorchannelmixer=aa=${_colorBg.opacity}[fg],  [0v][fg]overlay[vidWithOverlay],   [2:v][vidWithOverlay]scale2ref=${calcHeight}[logo][0v];[0v][logo]overlay=((W-w)/2):H-h-h-h[vv] ,  [vv]ass=$ass: fontsdir=$fontsdir"  ${useVidAudio ? '' : '-i $a'} -shortest -y -map 0:v ${useVidAudio ? '-map 0:a' : '-map 3:a'}  ${preview ? '-t 2' : '-q:v 0'}  $o',
      (session) async {
        try {
          final returnCode = await session.getReturnCode();

          if (ReturnCode.isSuccess(returnCode)) {
            print('yes success');
            activeSession = null;

            controller?.pause();
            if (preview) {
              setPlayerSource();
            } else {
              // GallerySaver.saveVideo(o, albumName: 'QuranVideoMaker')
              //     .then((bool? success) {
              //   print(success);
              //   print('THE VIDEO IS SAVED TO GALLERY');
              // });
              // Directory()

              File(o)
                  .copy(albumStoragePath + '/QuranVideoMaker/$projectId.mp4');
            }
          } else if (ReturnCode.isCancel(returnCode)) {
            // CANCEL
            print('caneled');
            activeSession = null;
          } else {
            // ERROR
            print('some error' + returnCode.toString());
            activeSession = null;
          }
        } catch (e) {
          print('error' + e.toString());
          activeSession = null;
        }
      },
      (logi) {
        log(logi.getMessage());
      },
      (stats) {
        final count = (stats.getTime() ~/ 1000);
        perc = double.parse(((count / total)).toStringAsFixed(2));

        notifyListeners();
        // onConvert(perc, session);
      },
    );
  }

  Future generatePreview() async {
    final c = Completer();
    final path = extStoragePath;

    final v = videoPath;
    final a = audioPath;
    final o = path + '/preview';
    final ass = path + '/subt.ass';
    String fontsdir = path + '/v2';

    final session = await FFprobeKit.getMediaInformation(v!);
    final information = session.getMediaInformation()!;

    final total = double.parse(information.getDuration()!).toInt();

    final outdir = Directory(o);

    if (!await outdir.exists()) {
      await outdir.create();
    } else {
      await outdir.delete(recursive: true); // clearing the previews
      await outdir.create();
    }
// MUBARAK:{chapters: [], streams: [
//   {
//     color_range: tv,
//     pix_fmt: yuv420p,
//     r_frame_rate: 30/1,
//     start_pts: 0,
//     duration_ts: 603,
//     duration: 20.100000,
//     bit_rate: 1126628,
//     field_order: progressive,
//     is_avc: true,
//     codec_tag_string: avc1,
//     avg_frame_rate: 30/1,
//     closed_captions: 0,
//     id: 0x1,
//     color_space: smpte170m,
//     nb_frames: 603,
//     codec_long_name: unknown,
//     height: 960,
//     color_primaries: smpte170m,
//     nal_length_size: 4,
//     chroma_location: left,
//     time_base: 1/30,
//     coded_height: 960,
//     level: 31,
//     color_transfer: smpte170m,
//     profile: 100,
//     bits_per_raw_sample: 8,
//     index: 0,
//     codec_name: h264,
//     tags: {creation_time: 2021-08-09T09:17:23.000000Z, handler_name: L-SMASH Video Handler, vendor_id: [0][0][0][0], language: und, encoder: AVC Coding},
//     start_time: 0.000000,
//     disposition: {metadata: 0, original: 0, visual_impaired: 0, forced: 0, attached_pic: 0, still_image: 0, descriptions: 0, captions: 0, dub: 0, karaoke: 0, default: 1, timed_thumbnails: 0, comment: 0, hearing_impaired: 0, lyrics: 0, dependent: 0, clean_effects: 0},
//     codec_tag: 0x31637661,
//     has_b_frames: 2,
//     refs: 1,
//     width: 540, coded_width: 540, codec_type: video}], format: {duration: 20.100000, start_time: 0.000000, bit_rate: 1130027, filename: /data/user/0/com.mubaraktech.quranvideo/cache/file_picker/Ghgh.mp4, size: 2839194, probe_score: 100, nb_programs: 0, nb_streams: 1, format_name: mov,mp4,m4a,3gp,3g2,mj2, tags: {creation_time: 2021-08-09T09:17:23.000000Z, major_brand: mp42, minor_version: 0, compatible_brands: mp42mp41isomavc1}}}

    final interval = total / 3;
    List<Duration> intervals = [];

    double time = 0;
    int count = 0;

    for (int i = 1; i <= 1; i++) {
      time += interval;

      final session = await FFmpegKit.executeAsync(
        // '-i $v -vf "ass=$ass:fontsdir=$fontsdir" -ss ${formatSubtitleDuration(Duration(seconds: time.floor()).inMilliseconds)} -vframes 1 -y $o/output$i.png',
        '-i $v -vf ass=$ass:fontsdir=$fontsdir -t 2 $o/output.mp4',
        (session) async {
          try {
            final returnCode = await session.getReturnCode();

            if (ReturnCode.isSuccess(returnCode)) {
              print('yes success');
              if (i == 1) {
                c.complete();
              }
            } else if (ReturnCode.isCancel(returnCode)) {
              // CANCEL
              print('caneled');
              c.completeError('cancel');
            } else {
              // ERROR
              print('some error' + returnCode.toString());
              c.completeError('error');
            }
          } catch (e) {
            print('error' + e.toString());
          }
        },
        (logi) {
          log(logi.getMessage());
        },
        (stats) {
          final count = (stats.getTime() ~/ 1000);

          // final session = stats.getSessionId();

          // onConvert(perc, session);
        },
      );
    }

    return c.future;
  }

  getPreviewImages() {
    print('SHAK');
    fileList = [];
    final imagesPath = extStoragePath + '/preview/';
    fileList = Directory(imagesPath).listSync();
    notifyListeners();
  }

  Future downloadFonts() async {
    final extSto = await getExternalStorageDirectory();
    for (var element in ayahs) {
      String filename = element.fontFamily() + '.ttf';
      arabicFontsUsed.add(filename);
    }

    print(arabicFontsUsed);
    for (var e in arabicFontsUsed) {
      final url =
          'https://github.com/quran/quran.com-frontend-v2/raw/master/app/assets/fonts/quran_fonts/v2/ttf/$e';

      final DynamicCachedFonts dynamicCachedFont = DynamicCachedFonts(
        fontFamily: e.split('.')[0],
        url: url,
      );

      final tes = await dynamicCachedFont
          .load(); // Downloads the font, caches and loads it.
      await tes.first.file.copy(extSto!.path + '/downloaded/$e');
    }
    notifyListeners();
  }

  Future loadFonts() async {
    final path = extStoragePath;
    Set<String> fontsUsed = {
      // 'Poppins.ttf',
      // 'Noto Sans Malayalam Medium.ttf',
      ...arabicFontsUsed,
    };

    final fontsPath = Directory(path + '/v2');

    final allFonts = Directory(path + '/downloaded');

    if (!await fontsPath.exists()) {
      await fontsPath.create(recursive: true);
    }

    if (await File(localFontPath!).exists()) {
      final fontFileName = localFontPath!.split('/').last;
      localFontFamily = fontFileName.split('.')[0];
      await File(localFontPath!).copy(fontsPath.path + '/$fontFileName');
    }

    if (await File(engFontPath!).exists()) {
      final fontFileName = engFontPath!.split('/').last;
      engFontFamily = fontFileName.split('.')[0];
      await File(engFontPath!).copy(fontsPath.path + '/$fontFileName');
    }

    for (var e in fontsUsed) {
      await File(allFonts.path + '/$e').copy(fontsPath.path + '/$e');
    }
  }

  String cleanUpEngSubtitle(String str) {
    final result = str.replaceAll(RegExp("<[^>]*>[^>]*<[^>]*>"), "");

    return result;
  }

  clearSpaces(String strr) {
    final result = strr.replaceAll(RegExp(r' '), "");

    return;
  }

  //0,00:00:12.76,00:00:50.10,Default,,0,0,0,,{\fad(0,0)\pos(350,500)}{\fnQCF2001}{\fs60}ﱆ ﱇ ﱈ ﱉ ﱊ{\fnBaloo Chettan 2\fs50}\N\N  All the praises and thanks be to Allâh, the Lord<sup foot_note=154319>1</sup> of the ‘Âlamîn (mankind, jinn and all that exists).<sup foot_note=154320>2</sup>{\fnPoppins\fs50}\N\N  All the praises and thanks be to Allâh, the Lord<sup foot_note=154319>1</sup> of the ‘Âlamîn (mankind, jinn and all that exists).<sup foot_note=154320>2</sup>
}
