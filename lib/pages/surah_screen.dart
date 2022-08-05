import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranvideo/models/translation.dart';
import 'package:quranvideo/provider/utils.dart';
import 'package:http/http.dart' as http;

class SurahScreen extends StatelessWidget {
  const SurahScreen({Key? key}) : super(key: key);

  showTranslationInfo(BuildContext context) async {
    final url = 'https://api.quran.com/api/v4/resources/translations';
    final res = await http.get(Uri.parse(url));
    Map<String, dynamic> out = json.decode(res.body);

    List result = out['translations'];
    List<Trans> trans = result
        .map((e) => Trans(
            id: e['id'].toString(), name: e['name'], lang: e['language_name']))
        .toList();

    trans.sort(
      (a, b) => a.lang.compareTo(b.lang),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          title: Text('Translations List'),
          content: ListView.builder(
            itemCount: trans.length,
            itemBuilder: ((context, index) => Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trans[index].lang.toUpperCase(),
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'ID: ' +
                            trans[index].id.toUpperCase() +
                            ' - ' +
                            trans[index].name,
                      ),
                    ],
                  ),
                )),
            // title: Text('List Of Translations'),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        TextField(
          controller: TextEditingController(
              text: context.read<Utils>().surahNo.toString()),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Surah No.',
          ),
          onChanged: (val) {
            context.read<Utils>().setSurahNo(int.parse(val));
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(
                    text: context.read<Utils>().from.toString()),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ayah Start',
                ),
                onChanged: (val) {
                  final num = int.tryParse(val);
                  if (num != null) {
                    context.read<Utils>().setFrom(num);
                  }
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                controller: TextEditingController(
                    text: context.read<Utils>().to.toString()),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ayah End',
                ),
                onChanged: (val) {
                  final num = int.tryParse(val);
                  if (num != null) {
                    context.read<Utils>().setTo(num);
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 35,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text('Translation Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left),
                IconButton(
                    icon: Icon(
                      Icons.info,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      showTranslationInfo(context);
                    }),
              ],
            )),
        SizedBox(
          height: 35,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(
                    text: context.read<Utils>().engTransId.toString()),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'English Trans ID',
                ),
                onChanged: (val) {
                  final num = int.tryParse(val);
                  if (num != null) {
                    context.read<Utils>().engTransId = num;
                  }
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                controller: TextEditingController(
                    text: context.read<Utils>().localTransId.toString()),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Local Trans ID',
                ),
                onChanged: (val) {
                  final num = int.tryParse(val);
                  if (num != null) {
                    context.read<Utils>().localTransId = num;
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
