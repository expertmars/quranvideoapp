import 'package:flutter/cupertino.dart';
import 'package:quranvideo/models/ayah.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Utils with ChangeNotifier {
  String name = 'Mubara';
  List<Ayah> ayahs = [
    // Ayah(glyph: 'testtes', number: 1, surah: 1, pageno: 1),
    // Ayah(glyph: 'testtedfs', number: 2, surah: 1, pageno: 1),
  ];
  int surahNo = 1;
  int from = 1;
  int to = 2;

  fetchSurahInfo() async {
    await fetchAyahs();
    await fetchTranslation(translationId: 80, engTranslationId: 203);
    ayahs.forEach((element) => print(element));
  }

  Future fetchAyahs() async {
    for (int i = from; i <= to; i++) {
      final verseKey = surahNo.toString() + ":" + i.toString();

      final url =
          'https://api.quran.com/api/v4/quran/verses/code_v2?chapter_number=$surahNo&verse_key=$verseKey';
      final res = await http.get(Uri.parse(url));
      // print(res.body);

      final data = json.decode(res.body);

      final glyph = data["verses"][0]['code_v2'];
      final page = data["verses"][0]['v2_page'];

      final ayah = Ayah(glyph: glyph, number: i, surah: surahNo, pageno: page);
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
}
