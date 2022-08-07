import 'package:flutter/material.dart';
import 'constants.dart';

class CustomButton extends StatelessWidget {
  @required
  final String title;
  @required
  final Function onPressed;
  final bool isLoading;
  final Color color;
  final Widget spinner;
  final Color textColor;
  final double height;
  final List<BoxShadow> boxShadow;
  final double width;
  final Duration duration;
  final bool hasBorder;
  final Color splashColor;
  final Color highlightColor;
  final String tooltip;
  final Widget child;
  final double textSize;
  final bool disabled;
  final double disabledOpacity;
  final EdgeInsets margin;
  final TextStyle textStyle;
  final double radius;
  final Color borderColor;
  final bool hasShadow;
  final double borderWidth;

  CustomButton({
    this.radius = 40,
    this.height = 60,
    this.disabled = false,
    this.disabledOpacity = 0.5,
    this.textStyle = poppinsMedium,
    this.duration = duration400,
    this.spinner = const CircularProgressIndicator(),
    this.tooltip,
    this.margin = const EdgeInsets.all(0),
    this.child,
    this.width,
    this.textSize = 20,
    this.isLoading = false,
    this.boxShadow,
    this.borderColor = Colors.transparent,
    this.borderWidth = 2,
    this.hasShadow = true,
    this.highlightColor = const Color(0x44FFFFFF),
    this.splashColor = const Color(0x00FFFFFF),
    this.hasBorder = false,
    this.color = Colors.transparent,
    this.textColor = Colors.white,
    this.onPressed,
    this.title = "Button",
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disabled,
      child: AnimatedOpacity(
        opacity: disabled ? disabledOpacity : 1.0,
        curve: fastOutSlowIn,
        duration: duration,
        child: AnimatedContainer(
          duration: duration,
          height: height,
          margin: margin,
          curve: fastOutSlowIn,
          width: width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(
                color: hasBorder ? borderColor : Colors.transparent,
                width: hasBorder ? borderWidth : 0),
            color: color,
            boxShadow: boxShadow ??
                [
                  BoxShadow(
                      blurRadius: 10,
                      color: hasShadow ? Colors.black38 : Colors.transparent)
                ],
            borderRadius: BorderRadius.circular(radius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: IconButton(
              highlightColor: highlightColor,
              splashColor: splashColor,
              onPressed: isLoading ? null : onPressed,
              icon: Center(
                child: isLoading
                    ? spinner
                    : child ??
                        Text(
                          title,
                          style: textStyle.copyWith(
                              color: textColor, fontSize: textSize),
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
