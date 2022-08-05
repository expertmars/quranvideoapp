import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:quranvideo/main.dart';
import 'package:quranvideo/provider/permission.dart';
import 'package:quranvideo/provider/utils.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  List<FileSystemEntity> dirs = [];

  void _listofFiles() async {
    final projectDir =
        Directory((await getExternalStorageDirectory())!.path + '/projects/');
    print(context.read<Utils>().extStoragePath + '/projects/');
    setState(() {
      dirs = projectDir.listSync(); //use your folder name insted of resume.
    });
  }

  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25),
        width: double.infinity,
        // height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 20, 28, 21),
              Color.fromARGB(255, 37, 73, 37),
            ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 60,
            ),
            Image.asset(
              'assets/logo.png',
              width: MediaQuery.of(context).size.width / 1.5,
            ),
            SizedBox(
              height: 25,
            ),
            newProjButton(onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => HomePage()));
            }),
            SizedBox(
              height: 25,
            ),
            ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: dirs.map((e) {
                print(e);
                final epoch = e.path.split('/').last;

                return menuItem(epoch);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuItem(String projectId) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(projectId));
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.amber.withOpacity(1),
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            context.read<Utils>().clearProjectData();
            context.read<Utils>().loadProject(projectId, context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.amber,
                        Color.fromARGB(255, 184, 149, 44),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.image_sharp,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date.toString().split(' ')[0],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${date.hour > 12 ? date.hour - 12 : date.hour}:${date.minute} ${date.hour > 12 ? 'PM' : 'AM'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(.5),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget newProjButton({required void Function() onTap}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            // Color.fromARGB(255, 0, 210, 237),
            Color.fromARGB(255, 5, 102, 26),
            Color.fromARGB(255, 195, 195, 0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 10,
          )
        ],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(18),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                  size: 55,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'New Project',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
