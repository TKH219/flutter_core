import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sw_core_package/bases/CoreScreenWidget.dart';
import 'package:sw_core_package/data/models/base/CoreResponse.dart';
import 'package:sw_core_package/resources/CoreColors.dart';
import 'package:sw_core_package/resources/CoreDimens.dart';
import 'package:sw_core_package/utilities/TypeDef.dart';
import 'package:sw_core_package/utilities/rxbus/CoreBusMessages.dart';
import 'package:sw_core_package/utilities/rxbus/rxbus.dart';

import 'CoreBloc.dart';

abstract class CoreScreenState<RS extends CoreResponse, CB extends CoreBloc<RS>,
    BS extends CoreScreenWidget> extends State<BS> {
  ProgressHUD _progressHUD;
  GlobalKey<ScaffoldState> scaffoldToastKey = new GlobalKey();

  @protected
  bool _loading = false;

  // for bloc
  ItemCreator<CB> _creator;

  @protected
  CB bloc;

  CoreScreenState(this._creator) {
    bloc = _creator();
    bloc.onReady();
  }

  bool haveInitialized = false;

  @override
  void initState() {
    super.initState();
    haveInitialized = false;
    _initProgressHUB();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // any related to context should be init here
    if (!haveInitialized) {
      initLocale(context);
      initWithContext(context);
      haveInitialized = true;
    }
  }

  void initLocale(BuildContext context);

  void _initProgressHUB() {
    _progressHUD = ProgressHUD(
      backgroundColor: CoreColors.loadingBackgroundColor,
      color: CoreColors.loadingColor,
      containerColor: CoreColors.Transparent,
      borderRadius: 5.0,
      loading: false,
    );
  }

  void showProgressHUD(bool shouldShow) {
    if (!mounted) return;
    Future.delayed(Duration.zero, () {
      _loading = shouldShow;
      _progressHUD.state.dismiss();
      if (_loading) {
        _progressHUD.state.show();
      }
    });
  }

  void initWithContext(BuildContext context) {
    registerBus();
  }

  void registerBus() {
    RxBus.register<ShowProgressHUB>(tag: this.bloc.busTag).listen((message) {
      showProgressHUD(message.shouldShow);
    });
    RxBus.register<ShowToastMessage>(tag: this.bloc.busTag).listen((message) {
      showToastMessage(message.toastText);
    });
  }

  void dismissDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 300), () {
      stateIsReady(context);
    });
    return Scaffold(
        appBar: createAppBarContent(context),
        key: scaffoldToastKey,
        body: Stack(
          children: <Widget>[
            createBodyContent(context),
            _progressHUD,
          ],
        ),
        resizeToAvoidBottomPadding: true);
  }

  @protected
  Widget createBodyContent(BuildContext context);

  @protected
  Widget createAppBarContent(BuildContext context) {
    return null;
  }

  @protected
  void stateIsReady(BuildContext context) {}

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: CoreColors.toastBackgroundColor,
        textColor: CoreColors.toastTextColor,
        fontSize: CoreDimens.SemiLargeTextSize);
  }

  void showSnackMessage(String message) {
    Future.delayed(Duration.zero, () {
      scaffoldToastKey.currentState.showSnackBar(new SnackBar(
        content: new Container(
            child: new Text(message, textAlign: TextAlign.center)),
        duration: new Duration(seconds: 3),
      ));
    });
  }

  void requestFocusNode(FocusNode focusedNode) {
    FocusScope.of(context).requestFocus(focusedNode);
  }

  @override
  void dispose() {
    RxBus.destroy(tag: this.bloc.busTag);
    super.dispose();
  }
}
