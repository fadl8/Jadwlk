import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jedwalak/controls/colors.dart';



void toast(BuildContext context, {String txt, bool pop = false, Color color}) {
  pop ? Navigator.of(context).pop() : pop = false;
  Fluttertoast.showToast(
      msg: txt == null ?"internt_conf" : txt.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      
      timeInSecForIos: 1,
      backgroundColor: color == null ? prymaryColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
