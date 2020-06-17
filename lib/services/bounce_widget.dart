import 'package:flutter/material.dart';

class BounceOnTap extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double beginScale;
  final int onTapSequence;
  final double endScale;
  final Curve curve;
  final Function onTap;

  BounceOnTap({
    this.child,
    this.onTapSequence = 3,
    this.endScale = 0.85,
    this.beginScale = 1.0,
    this.onTap,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.fastOutSlowIn,
  });

  @override
  _BounceOnTapState createState() => _BounceOnTapState();
}

class _BounceOnTapState extends State<BounceOnTap>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scale;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scale = Tween<double>(
      begin: widget.beginScale,
      end: widget.endScale,
    )
        .chain(
          CurveTween(
            curve: widget.curve,
          ),
        )
        .animate(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTap: () {
          switch (widget.onTapSequence) {
            case 1:
              if (widget.onTap != null) widget.onTap();
              _controller.forward().whenComplete(() {
                _controller.reverse();
              });
              break;
            case 2:
              _controller.forward().whenComplete(() {
                if(widget.onTap!=null)
                  widget.onTap();
                _controller.reverse();
              });
              break;
            case 3:
              _controller.forward().whenComplete(() {
                _controller.reverse().whenComplete(() {
                  if(widget.onTap!=null)
                    widget.onTap();
                });
              });
              break;
            default:
              _controller.forward().whenComplete(() {
                if(widget.onTap!=null)
                  widget.onTap();
                _controller.reverse();
              });
          }
        },
        onTapDown: (s) {
          _controller.forward();
        },
        onTapUp: (s) {
          _controller.reverse();
        },
        onTapCancel: () {
          _controller.reverse();
        },
        child: widget.child,
      ),
    );
  }
}
