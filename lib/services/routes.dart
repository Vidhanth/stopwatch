import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class FadeIn extends PageRouteBuilder{
  Widget widget;
  Duration duration;
  FadeIn({this.widget, this.duration}):super(
      transitionDuration: duration ?? Duration(milliseconds: 300),
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secAnimation,
          Widget child) {
        return FadeTransition(
            opacity: animation, child: child);
      },
      pageBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secAnimation) =>
      widget
  );
}

class SharedAxisPageRoute extends PageRouteBuilder {
  SharedAxisPageRoute({Widget page, SharedAxisTransitionType transitionType,Duration duration}) : super(
    transitionDuration: duration,
    pageBuilder: (
        BuildContext context,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
        ) => page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
      return SharedAxisTransition(
        animation: primaryAnimation,
        secondaryAnimation: secondaryAnimation,
        transitionType: transitionType,
        child: child,
      );
    },
  );
}