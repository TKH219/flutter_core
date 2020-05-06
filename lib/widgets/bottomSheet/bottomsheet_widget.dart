import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sw_core_package/resources/CoreDimens.dart';

class CoreBottomSheet {
  static final CoreBottomSheet _singleton = CoreBottomSheet._internal();

  factory CoreBottomSheet() {
    return _singleton;
  }
  CoreBottomSheet._internal();

  PersistentBottomSheetController sheetController;

  void show(BuildContext context, List<Widget> childs) {
    sheetController = showBottomSheet(
        context: context,
        builder: (context) => BottomSheetWidget(
              childs: childs,
            ));
  }
}

class BottomSheetWidget extends StatefulWidget {
  BottomSheetWidget(
      {Key key,
      this.childs,
      this.backgroundColor,
      this.borderRadius,
      this.boxShadow})
      : super(key: key);

  List<Widget> childs = [];
  Color backgroundColor = Colors.white;
  BorderRadiusGeometry borderRadius =
      BorderRadius.all(Radius.circular(CoreDimens.dp_15));
  List<BoxShadow> boxShadow = [
    BoxShadow(
        blurRadius: CoreDimens.dp_10,
        color: Colors.grey[300],
        spreadRadius: CoreDimens.dp_5)
  ];

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: CoreDimens.dp_20,
          left: CoreDimens.dp_20,
          right: CoreDimens.dp_20,
          bottom: CoreDimens.dp_20),
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          boxShadow: widget.boxShadow),
      child: SingleChildScrollView(
        child: Column(
          children: widget.childs,
        ),
      ),
    );
  }
}
