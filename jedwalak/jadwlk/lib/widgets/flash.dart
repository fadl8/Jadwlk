import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

flushbar(
  title,
  msg,
) {
  return Flushbar<bool>(
    title: title,
    showProgressIndicator: true,
    message: msg,
    isDismissible: false, 
    
  );  
}
