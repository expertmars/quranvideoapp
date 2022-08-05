import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:dynamic_cached_fonts/dynamic_cached_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quranvideo/models/ayah.dart';
import 'package:quranvideo/provider/utils.dart';

class AyahEditorScreen extends StatefulWidget {
  const AyahEditorScreen({Key? key}) : super(key: key);

  @override
  State<AyahEditorScreen> createState() => _AyahEditorScreenState();
}

class _AyahEditorScreenState extends State<AyahEditorScreen> {
  List<Ayah> ayahs = [];
  EditingType type = EditingType.ayah;

  TextEditingController t = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ayahs = context.watch<Utils>().ayahs;
    final unSelectedStyle = ElevatedButton.styleFrom(
        elevation: 0,
        primary: Colors.transparent,
        onPrimary: Colors.black,
        shadowColor: Colors.transparent);
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TextButton.icon(
          //     icon: Icon(Icons.undo), onPressed: () {}, label: Text('UNDO')),
          // TextButton.icon(
          //     icon: Icon(Icons.redo), onPressed: () {}, label: Text('REDO')),
          ElevatedButton(
            child: Text('Arabic'),
            onPressed: () {
              setState(() {
                type = EditingType.ayah;
              });
            },
            style: type == EditingType.ayah ? null : unSelectedStyle,
          ),
          ElevatedButton(
              child: Text('English'),
              onPressed: () {
                setState(() {
                  type = EditingType.eng;
                });
              },
              style: type == EditingType.eng ? null : unSelectedStyle),
          ElevatedButton(
              child: Text('Local'),
              onPressed: () {
                setState(() {
                  type = EditingType.local;
                });
              },
              style: type == EditingType.local ? null : unSelectedStyle),
        ],
      ),
      ...ayahs
          .mapIndexed(
            (i, e) => AyahEditFormField(
                index: i, ayah: e, key: ValueKey(e.id), type: type),
          )
          .toList()
    ]);
  }
}

class AyahEditFormField extends StatelessWidget {
  final int index;
  final Ayah ayah;
  final EditingType type;

  const AyahEditFormField(
      {Key? key, required this.index, required this.ayah, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController t;

    if (type == EditingType.ayah) {
      t = TextEditingController(text: ayah.glyph);
    } else if (type == EditingType.eng) {
      t = TextEditingController(text: ayah.eng);
    } else {
      t = TextEditingController(text: ayah.local);
    }

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Slidable(
        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),
          dragDismissible: false,

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {}),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (ctx) {
                context.read<Utils>().delAyah(ayah.id);
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: TextFormField(
          controller: t,
          maxLines: 3,
          textDirection: TextDirection.ltr,
          onChanged: (newVal) {
            //if (type != EditingType.ayah) {
            context.read<Utils>().updateTranslation(ayah.id, type, newVal);
            //}
          },
          style: TextStyle(fontFamily: ayah.fontFamily(), fontSize: 20),
          decoration: InputDecoration(
              label: Text((index + 1).toString()),
              suffixIcon: IconButton(
                icon: Icon(Icons.cut),
                onPressed: () {
                  final cursorPos = t.selection.base.offset;
                  context.read<Utils>().splitAyah(type, ayah.id, cursorPos);
                },
              )),
        ),
      ),
    );
  }
}
