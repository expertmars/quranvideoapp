import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quranvideo/models/ayah.dart';
import 'package:quranvideo/pages/video_screen.dart';
import 'package:quranvideo/widgets/color_selector.dart';

import '../provider/utils.dart';

class FontSettingItem extends StatelessWidget {
  final EditingType type;

  const FontSettingItem({required this.type, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = 'Arabic';
    String fontName = 'QCF2';
    if (type == EditingType.ayah) {
      title = 'Arabic';
      fontName = 'QCF2';
    } else if (type == EditingType.eng) {
      title = 'English';
      fontName =
          context.watch<Utils>().engFontPath?.split('/').last ?? 'Poppins';
    } else {
      title = 'Local';
      fontName =
          context.watch<Utils>().localFontPath?.split('/').last ?? 'Default';
    }

    print(context.watch<Utils>().engFontSize);

    return Stack(
      children: [
        Positioned(left: 24, child: Text(title)),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            // border: Border.all(width: 1, color: Colors.black12),
            color: Colors.blue.withOpacity(.1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.read<Utils>().selectFont(type);
                  },
                  onLongPress: () {
                    print('ta[ed');
                    context.read<Utils>().resetToDefaultFont(type);
                  },
                  child: Text(
                    type == EditingType.ayah ? 'QCF2' : fontName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      // fontFamily: 'Noto Sans Malayalam Medium',
                      // decoration: TextDecoration.underline,
                      fontSize: 18,
                      color: Colors.black,
                      // fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: TextEditingController(
                      text:
                          context.watch<Utils>().getFontSize(type).toString()),
                  onChanged: (val) {
                    final res = int.tryParse(val);
                    if (res != null) {
                      context.read<Utils>().setFontSize(res, type);
                    }
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white54,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () async {
                    Color c;
                    final utils = context.read<Utils>();
                    if (type == EditingType.eng) {
                      c = utils.engColor;
                    } else if (type == EditingType.ayah) {
                      c = utils.ayahColor;
                    } else {
                      c = utils.localColor;
                    }
                    final color = await showColorSelector(context, c);
                    if (color != null) {
                      context.read<Utils>().setFontColor(color, type);
                    }
                    print(color);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      color: context.watch<Utils>().getFontColor(type),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            width: 14,
            height: 14,
            child: Checkbox(
              value: context.watch<Utils>().getEnable(type),
              onChanged: (val) {
                print('dsf');
                context.read<Utils>().setEnable(val!, type);
              },
            ),
          ),
        ),
      ],
    );
  }
}
