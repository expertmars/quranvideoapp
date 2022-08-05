import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:quranvideo/provider/utils.dart';

Future<Color?> showColorSelector(BuildContext context, Color color,
    {showAlpha = false}) async {
  Color? selectedColor;
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        //
        // Use Material color picker:
        //
        child: Container(
          padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
          child: ColorPicker(
            enableAlpha: showAlpha ? true : false,
            hexInputBar: true,
            showLabel: false,

            displayThumbColor: true,
            pickerAreaBorderRadius: BorderRadius.circular(4),
            pickerColor: color,
            // pickerColor: context.watch<Utils>().colorBg ?? Colors.black,
            onColorChanged: (col) {
              // changeColor(col);
              selectedColor = col;
              print(col);
            },

            // showLabel: true, // only on portrait mode
          ),
        ),
        // MaterialPicker(
        //     pickerColor: context.watch<Utils>().colorBg ?? Colors.black,
        //     onColorChanged: (col) {
        //       // changeColor(col);
        //       selectedColor = col;
        //     },
        //
        // Use Block color picker:
        //
        // child: BlockPicker(
        //   pickerColor: context.watch<Utils>().colorBg ?? Colors.black,
        //   onColorChanged: (col) {
        //     // changeColor(col);
        //     selectedColor = col;
        //   },
        // ),
        //
        // child: MultipleChoiceBlockPicker(
        //   pickerColors: currentColors,
        //   onColorsChanged: changeColors,
        // ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Got it'),
          onPressed: () {
            // setState(() => currentColor = pickerColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
  return selectedColor;
}
