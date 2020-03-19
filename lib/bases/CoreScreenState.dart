import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
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
  var isLargeScreen = false;
  var isSafeArea = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initComponents(context);
  }

  void initComponents(BuildContext context) {
    // any related to context should be init here
    if (!haveInitialized) {
      initProgressHUB();
      initOrientationMode(context);
      initWithContext(context);
      registerRxBus();
      haveInitialized = true;
    }
  }

  void initWithContext(BuildContext context);

  void initProgressHUB() {
    _progressHUD = ProgressHUD(
      backgroundColor: CoreColors.loadingBackgroundColor,
      color: CoreColors.loadingColor,
      containerColor: CoreColors.Transparent,
      borderRadius: 5.0,
      loading: false,
    );
  }

  void initOrientationMode(BuildContext context) {
    if (Device.get().isTablet) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }
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

  void registerRxBus() {
    RxBus.register<ShowProgressHUB>(tag: this.bloc.busTag).listen((message) {
      showProgressHUD(message.shouldShow);
    });
    RxBus.register<ShowToastMessage>(tag: this.bloc.busTag).listen((message) {
      showToastMessage(message.toastText);
    });
    RxBus.register<ShowSnackMessage>(tag: this.bloc.busTag).listen((message) {
      showSnackMessage(message.message);
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

    Widget mainContent = GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: isLargeScreen ? buildTabletLayout(context) : buildMobileLayout(context),
    );
    Widget scaffold = Material(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: scaffoldToastKey,
            appBar: createAppBarContent(context),
            body: isSafeArea?SafeArea(
                bottom: false,
                child:mainContent
            ): mainContent,

          bottomNavigationBar: bottomNavigationBar(context),
        )
    );

                return Stack(
                    children: <Widget>[scaffold, _progressHUD],
                    alignment: Alignment.center);
  }

  @protected
  Widget createAppBarContent(BuildContext context) {
    return null;
  }
  @protected
  Widget bottomNavigationBar(BuildContext context){
    return null;
  }

  @protected
  Widget buildMobileLayout(BuildContext context);

  Widget buildTabletLayout(BuildContext context) {
    return buildMobileLayout(context);
  }

  @protected
  void stateIsReady(BuildContext context) {}

  void showToastMessage(String message,
      [ToastGravity gravity = ToastGravity.CENTER]) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: gravity,
        timeInSecForIos: 1,
        backgroundColor: CoreColors.toastBackgroundColor,
        textColor: CoreColors.toastTextColor,
        fontSize: CoreDimens.SemiLargeTextSize);
  }

  void showSnackMessage(String message) {
   Future.delayed(Duration.zero, () {
      scaffoldToastKey.currentState.showSnackBar(snackBar(message));
    });
  }

  Widget snackBar(String message){
    return new SnackBar(
      content: new Container(
          child: new Text(message, textAlign: TextAlign.center)),
      duration: new Duration(seconds: 3),
    );
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
