import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:newsfeed/models/line_chart.dart';
import 'package:newsfeed/ui/widgets/path_painter.dart';

class AnimatedGraph extends StatefulWidget {
  final LineChart lineChart;
  final bool resetAnimation;

  const AnimatedGraph({Key key, this.lineChart, this.resetAnimation = false})
      : super(key: key);

  @override
  _AnimatedGraphState createState() => _AnimatedGraphState();
}

class _AnimatedGraphState extends State<AnimatedGraph>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Offset _tapPos;
  bool _horizontalDragActive = false;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedGraph oldWidget) {
    if (widget.resetAnimation && _controller.value == 1) {
      print("reset");
      _controller.reset();
      _controller.forward();
    }
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      widget.lineChart.scaleChart(constraints.maxWidth, constraints.maxHeight);
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (tap) {
          _horizontalDragActive = true;
          _tapPos = tap.localPosition;
          setState(() {});
        },
        onTapUp: (tap) {
          _horizontalDragActive = false;
          _tapPos = tap.localPosition;
          setState(() {});
        },

        onHorizontalDragUpdate: (tap) {
          _horizontalDragActive = true;
          _tapPos = tap.localPosition;
          setState(() {});
        },

        onHorizontalDragEnd: (details) =>
            setState(() => _horizontalDragActive = false),
        //        onVerticalDragUpdate: (tap) {
//          _horizontalDragActive = true;
//          _tapPos = tap.localPosition;
//          setState(() {});
//        },
//        onVerticalDragEnd: (details) =>
//            setState(() => _horizontalDragActive = false),

//        onPanUpdate: (details) {
//          print("pan");
//          _horizontalDragActive = true;
//          _tapPos = details.localPosition;
//          setState(() {
//
//          });
//        },
//        onPanEnd: (details) => setState(() => _horizontalDragActive = false),
        onTap: () {
//            if (_controller.isCompleted) {
//              _controller.reverse();
//            } else {
//              _controller.forward();
//            }
        },
        child: CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: PathPainter(_controller.value, widget.lineChart, _tapPos,
              _horizontalDragActive),
        ),
      );
    });
  }
}
