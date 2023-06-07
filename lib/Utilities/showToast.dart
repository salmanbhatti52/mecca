import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showDropDown() {}
void showToastSuccess(String? msg, FToast fToast,
    {Color toastColor = Colors.white,
    int seconds = 2,
    double fontSize = 16.0}) {
  final Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.green,
    ),
    child: Text(
      msg ?? '',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: toastColor,
        fontSize: fontSize,
        fontFamily: 'UBUNTU',
        letterSpacing: 1.0,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: seconds),
  );
}

void showToastError(
  String? msg,
  FToast fToast, {
  Color toastColor = Colors.white,
  int seconds = 2,
  double fontSize = 16.0,
}) {
  final Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.red,
    ),
    child: Text(
      msg ?? '',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: toastColor,
        fontSize: fontSize,
        fontFamily: 'Lora',
        letterSpacing: 1.0,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.CENTER,
    toastDuration: Duration(seconds: seconds),
  );
}
