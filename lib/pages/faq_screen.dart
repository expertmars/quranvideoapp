import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Q: How to use custom fonts'),
          Text(
              'A: You can use custom fonts by selecting the proper font file, make sure the name of the file is the FontFamily name.'),
          SizedBox(
            height: 15,
          ),
          Text(
              'Q: The video is not showing any texts (ayahs, translations, etc.) '),
          Text(
              'A: This is mostly because you used an incorrect font file, or forgot to rename the file to correct "FontFamily name.ttf" format. Note that the invalid font file on a disabled text (english or local) can cause the problem. So please reset the font if you are not using it.'),
          SizedBox(
            height: 15,
          ),
          Text('Q: How to reset the font to use default ?'),
          Text(
              'A: If you need to reset font in case you ran into some problems, you can hold the font name and it will be reseted to use default.'),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
