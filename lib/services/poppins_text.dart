import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:auto_size_text/auto_size_text.dart';


class PoppinsRegular extends StatelessWidget {
  final String text;
  final double textSize;
  final Color textColor;
  final FontStyle fontStyle;
  final TextAlign textAlign;

  PoppinsRegular({
    this.text = "some text",
    this.textColor = const Color(0xFFFFFFFF),
    this.textSize = 15.0,
    this.textAlign = TextAlign.start,
    this.fontStyle = FontStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: textAlign,
      style: poppinsRegular.copyWith(
        color: textColor,
        fontSize: textSize,
        fontStyle: fontStyle,
      ),
    );
  }
}


class PoppinsBold extends StatelessWidget {
  final String text;
  final double textSize;
  final Color textColor;
  final FontStyle fontStyle;
  final TextAlign textAlign;

  PoppinsBold({
    this.text = "some text",
    this.textColor = const Color(0xFFFFFFFF),
    this.textSize = 15.0,
    this.textAlign = TextAlign.start,
    this.fontStyle = FontStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: textAlign,
      style: poppinsBold.copyWith(
        color: textColor,
        fontSize: textSize,
        fontStyle: fontStyle,
      ),
    );
  }
}


class PoppinsLight extends StatelessWidget {
  final String text;
  final double textSize;
  final Color textColor;
  final FontStyle fontStyle;
  final TextAlign textAlign;

  PoppinsLight({
    this.text = "some text",
    this.textColor = const Color(0xFFFFFFFF),
    this.textSize = 15.0,
    this.textAlign = TextAlign.start,
    this.fontStyle = FontStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: textAlign,
      style: poppinsLight.copyWith(
        color: textColor,
        fontSize: textSize,
        fontStyle: fontStyle,
      ),
    );
  }
}


class PoppinsMedium extends StatelessWidget {
  final String text;
  final double textSize;
  final Color textColor;
  final FontStyle fontStyle;
  final TextAlign textAlign;

  PoppinsMedium({
    this.text = "some text",
    this.textColor = const Color(0xFFFFFFFF),
    this.textSize = 15.0,
    this.textAlign = TextAlign.start,
    this.fontStyle = FontStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: textAlign,
      style: poppinsMedium.copyWith(
        color: textColor,
        fontSize: textSize,
        fontStyle: fontStyle,
      ),
    );
  }
}
