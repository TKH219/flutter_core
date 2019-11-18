import 'package:flutter/material.dart';
import 'package:sw_core_package/sw_core_package.dart';

// ignore: must_be_immutable
class CoreInputField extends StatefulWidget {
  String hint;
  final bool isPasswordField;
  final FocusNode focusNode;
  final TextInputType inputType;
  final IconData icon;
  final String iconAssetPath;
  final bool isAutoFocused;
  String errorText;
  dynamic Function(String) onChanged;
  dynamic Function(String) onSubmitted;

  _CoreInputFieldState _inputState;
  final bool bottomBorderOnly;

  CoreInputField(
      {this.hint,
      this.isPasswordField,
      this.icon,
      this.iconAssetPath = "",
      this.errorText,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.inputType = TextInputType.text,
      this.isAutoFocused = false,
      this.bottomBorderOnly = false});

  @override
  _CoreInputFieldState createState() {
    if (_inputState == null) {
      _inputState = _CoreInputFieldState(isPasswordField);
    }
    return _inputState;
  }

  void setErrorText(String errorText) {
    if (_inputState != null) {
      _inputState.setErrorText(errorText);
    }
  }

  void setHintText(String hintText) {
    if (_inputState != null) {
      _inputState.setHintText(hintText);
    }
  }

  void setOnChangedListener(dynamic Function(String) onChanged) {
    if (_inputState != null) {
      _inputState.setOnChangedListener(onChanged);
    }
  }

  void setText(String text) {
    if (_inputState != null) {
      _inputState.setText(text);
    }
  }
}

// ////
class _CoreInputFieldState extends State<CoreInputField> {
  var _textController = new TextEditingController();
  bool _passwordVisible = false;

  _CoreInputFieldState(this._passwordVisible);

  void setText(String text) {
    setState(() {
      _textController.text = text;
    });
  }

  void setErrorText(String errorText) {
    setState(() {
      widget.errorText = errorText;
    });
  }

  void setHintText(String hintText) {
    setState(() {
      widget.hint = hintText;
    });
  }

  void setOnChangedListener(dynamic Function(String) onChanged) {
    setState(() {
      widget.onChanged = onChanged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Container(
      margin: EdgeInsets.only(
          top: CoreDimens.defaultPadding,
          left: CoreDimens.defaultPadding,
          right: CoreDimens.defaultPadding,
          bottom: 0),
      child: TextField(
        controller: _textController,
        keyboardType: widget.inputType,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        focusNode: widget.focusNode,
        autofocus: widget.isAutoFocused,
        obscureText: _passwordVisible,
        style: TextStyle(
          color: CoreColors.primaryTextColor,
        ),
        cursorColor: CoreColors.highlightColor,
        decoration: InputDecoration(
          border: buildBorder(isFocusing: false),
          focusedBorder: buildBorder(isFocusing: true),
          prefixIcon: buildPrefixIcon(),
          suffixIcon: widget.isPasswordField ? buildObscureIcon(context) : null,
          errorText: widget.errorText,
          errorStyle: TextStyle(color: CoreColors.errorTextColor),
          hintText: widget.hint,
          hintStyle: TextStyle(
              color: CoreColors.inputHintColor,
              fontSize: CoreDimens.SemiLargeTextSize),
          contentPadding: const EdgeInsets.only(
              top: CoreDimens.defaultPadding,
              right: CoreDimens.defaultPadding,
              bottom: CoreDimens.defaultPadding,
              left: 5.0),
        ),
      ),
    ));
  }

  Widget buildObscureIcon(BuildContext context) {
    return IconButton(
      icon: Icon(
        // Based on passwordVisible state choose the icon
        _passwordVisible ? Icons.visibility_off : Icons.visibility,
        color: CoreColors.inputHintColor,
      ),
      onPressed: () {
        // Update the state i.e. toggle the state of passwordVisible variable
        setState(() {
          _passwordVisible ? _passwordVisible = false : _passwordVisible = true;
        });
      },
    );
  }

  Widget buildPrefixIcon() {
    var result;
    if (widget.iconAssetPath.isEmpty) {
      result = Icon(
        widget.icon,
        color: CoreColors.inputHintColor,
      );
    } else {
      result = Container(
        padding: EdgeInsets.all(CoreDimens.dp_13),
        child: CoreImageUtils.getImage(widget.iconAssetPath, BoxFit.contain, CoreDimens.dp_10, CoreDimens.dp_10),
      );
    }
    return result;
  }

  InputBorder buildBorder({bool isFocusing = false}) {
    var borderWidget;
    var borderSide = BorderSide(
        width: 2.0,
        color: isFocusing
            ? CoreColors.highlightColor
            : CoreColors.primaryTextColor);

    if (widget.bottomBorderOnly) {
      borderWidget = UnderlineInputBorder(borderSide: borderSide);
    } else {
      borderWidget = OutlineInputBorder(
        borderSide: borderSide,
        borderRadius:
            BorderRadius.all(Radius.circular(CoreDimens.defaultRadius)),
      );
    }
    return borderWidget;
  }
}
