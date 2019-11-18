
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sw_core_package/resources/CoreColors.dart';

class CoreDialogUtils {

  //Dialogs
  static void showAlertDialog(
      String title, String errorContent, BuildContext context,
      [VoidCallback callback, bool barrierDismiss = true]) {
    var header = new Container(
        child: new Text(title,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
        color: Colors.white,
        padding: new EdgeInsets.only(top: 15.0));
    var content = new Container(
        padding: new EdgeInsets.only(
            left: 15.0, right: 10.0, top: 10.0, bottom: 10.0),
        child: new Text(errorContent));
    var buttons = new FlatButton(
      child: Container(
          alignment: Alignment.center,
          width: double.maxFinite,
          margin: EdgeInsets.all(15.0),
          child: Text('OK',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
              new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0))),
      onPressed: () {
        Navigator.of(context).pop();
        if (callback != null) {
          callback();
        }
      },
    );
    var column = new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      header,
      content,
      Container(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        width: double.maxFinite,
        height: 0.5,
        color: CoreColors.primaryTextColor,
      ),
      buttons
    ]);
    var container = Container(
      width: double.maxFinite,
      child: column,
      color: Colors.white,
    );

    showPopup(context, container, barrierDismiss);
  }

  static void showPopup(BuildContext context, Widget widget,
      [bool barrierDismiss = true]) {
    Dialog dialog = new Dialog(
      child: widget,
    );

    showContentDialog(context, widget, dialog, barrierDismiss);
  }

  static Future<Null> showContentDialog(
      BuildContext context, Widget widget, Dialog dialog,
      [bool barrierDismiss = true]) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: barrierDismiss, // user must tap button!
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

}