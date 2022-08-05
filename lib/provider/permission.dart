import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> hasAcceptedPermissions() async {
  if (Platform.isAndroid) {
    if (await _requestPermission(Permission.storage) &&
        // access media location needed for android 10/Q
        await _requestPermission(Permission.accessMediaLocation) &&
        // manage external storage needed for android 11/R
        await _requestPermission(Permission.manageExternalStorage)) {
      return true;
    } else {
      return false;
    }
  }
  if (Platform.isIOS) {
    if (await _requestPermission(Permission.photos)) {
      return true;
    } else {
      return false;
    }
  } else {
    // not android or ios
    return false;
  }
}

Future<bool> _requestPermission(Permission p) async {
  if (!await p.isGranted) {
    Fluttertoast.showToast(
        msg: 'Need permission to save videos to your gallery',
        toastLength: Toast.LENGTH_LONG);
    final st = await p.request();
    return st.isGranted;
  }
  return true;
}
