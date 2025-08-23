import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Component {
  static Widget showLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          SizedBox(height: 15),
          Text(
            "Loading...",
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  static successToast(BuildContext context, String msg) =>
      getToast(context, msg, Colors.greenAccent);
  static errorToast(BuildContext context, String msg) =>
      getToast(context, msg, Colors.redAccent);

  static getToast(context, msg, color) {
    return showToast(
      msg,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.center,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 4),
      curve: Curves.elasticOut,
      backgroundColor: color,
      reverseCurve: Curves.linear,
    );
  }
}
