import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/models/line_chart.dart';
import 'package:newsfeed/utility/path_util.dart';

class PathPainter extends CustomPainter {
  final double _progress;
  final LineChart _lineChart;
  final Offset _tapPosition;
  final bool _drawToolTip;
  final double tooltipWidth;
  final double tooltipHeight;
  final double offsetTooltip;
  final bool rotateAxisX;

  PathPainter(
    this._progress,
    this._lineChart,
    this._tapPosition,
    this._drawToolTip, {
    this.tooltipWidth = 100.0,
    this.tooltipHeight = 100.0,
    this.rotateAxisX = false,
    this.offsetTooltip,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    double lineWidth = 4.0;
    _lineChart.chartLines.forEach((line) {
      int index = 0;
      int lineIndex = _lineChart.chartLines.indexOf(line);

      List<Path> paths = PathUtil.createAnimatedPath(
          _lineChart.getPathCache(lineIndex),
          _progress,
          _lineChart.distances(lineIndex));
      for (var p in paths) {
        if (_lineChart.alignmentStart(lineIndex).length == index) {
          break;
        }

        final Gradient gradient = new LinearGradient(
            begin: _lineChart.alignmentStart(lineIndex)[index],
            end: _lineChart.alignmentEnd(lineIndex)[index],
            colors: paths.indexOf(p) == paths.length - 1
                ? <Color>[
                    Colors.green,
                    Colors.yellow,
                  ]
                : <Color>[
                    Colors.green,
                    Colors.green,
                  ],
            stops: [0, 1]);

        index += 1;
        final Rect lineRect = p.getBounds();

        Paint paint = new Paint()
          ..strokeWidth = lineWidth
          ..color = Colors.black
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;
        paint.shader = gradient.createShader(lineRect);
        canvas.drawPath(
          p,
          paint,
        );
      }
    });
    _drawGrid(canvas, size);
    _drawValues(canvas, size);
    if (_drawToolTip) _drawHighlightPoint(canvas, size);

    if (_drawToolTip) _drawTooltip(canvas, size);
  }

  _drawGrid(Canvas canvas, Size size) {
    final Paint _gridPainter = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black26;

    for (double i = 0; i <= _lineChart.stepXGrid; i++) {
//      canvas.drawLine(Offset(0, i * _lineChart.gridHeightStep),
//          Offset(size.width, i * _lineChart.gridHeightStep), _gridPainter);

      canvas.drawLine(Offset(i * _lineChart.gridWidthStep, 0),
          Offset(i * _lineChart.gridWidthStep, size.height), _gridPainter);
    }
    for (double i = 0; i <= _lineChart.stepYGrid; i++) {
      canvas.drawLine(Offset(0, i * _lineChart.gridHeightStep),
          Offset(size.width, i * _lineChart.gridHeightStep), _gridPainter);
//
//      canvas.drawLine(Offset(i * _lineChart.gridWidthStep, 0),
//          Offset(i * _lineChart.gridWidthStep, size.height), _gridPainter);
    }

  }

  _drawTooltip(Canvas canvas, Size size) {
    Paint _tooltipPainter = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withAlpha(160);

    Paint _tooltipBorderPainter = new Paint()
      ..strokeWidth = 2
      ..color = Colors.black38
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    Point closestPoint =
        _lineChart.findClosest(Point(_tapPosition.dx, _tapPosition.dy), 0);
    double offset = 10;
    if (closestPoint.x - tooltipWidth / 2 - offset < 0) {
      double posY = closestPoint.y - tooltipHeight / 2;
      if (posY + tooltipHeight > size.height) {
        posY = posY - tooltipHeight / 2;
      }
      //Draw tooltip bordered box:
      Rect tooltipRect = Rect.fromLTWH(
          closestPoint.x + offset, posY, tooltipWidth, tooltipHeight);
      Rect tooltipBorderRect = Rect.fromLTWH(
          closestPoint.x + offset, posY, tooltipWidth, tooltipHeight);

      canvas.drawRect(tooltipRect, _tooltipPainter);
      //draw border of rect
      canvas.drawRect(tooltipBorderRect, _tooltipBorderPainter);

      TextSpan span = TextSpan(
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w400, fontSize: 12),
          text: 'x: ' + closestPoint.x.toStringAsFixed(2));
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.right,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas,
          Offset(closestPoint.x - tp.width + 5 + tooltipWidth / 2, posY));
    } else {
      double posY = closestPoint.y - tooltipHeight / 2;
      if (posY + tooltipHeight > size.height) {
        posY = posY - tooltipHeight / 2;
      }
      //Draw tooltip bordered box:
      Rect tooltipRect = Rect.fromLTWH(closestPoint.x - tooltipWidth - offset,
          posY, tooltipWidth, tooltipHeight);
      Rect tooltipBorderRect = Rect.fromLTWH(
          closestPoint.x - tooltipWidth - offset,
          posY,
          tooltipWidth,
          tooltipHeight);

      canvas.drawRect(tooltipRect, _tooltipPainter);
      //draw border of rect
      canvas.drawRect(tooltipBorderRect, _tooltipBorderPainter);

      TextSpan span = TextSpan(
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w400, fontSize: 12),
          text: 'x: ' + closestPoint.x.toStringAsFixed(2));
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.right,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas,
          Offset(closestPoint.x - tp.width + 5 - tooltipWidth / 2, posY));
    }
  }

  _drawValues(Canvas canvas, Size size) {

    for (int i = 0; i < _lineChart.axisXValues.length ; i++) {
      TextSpan spanX = TextSpan(
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w400, fontSize: 10),
          text:
          '${_lineChart.axisXValues[ i]}');
      TextPainter tpX = TextPainter(
          text: spanX,
          textAlign: TextAlign.right,
          textDirection: TextDirection.ltr);
      tpX.layout();
      if(!rotateAxisX){
        double x = (i * _lineChart.gridWidthStep)   - tpX.width/2;

        tpX.paint(
            canvas,
            Offset( x ,
                size.height + tpX.height));


      }
      else{

      canvas.save();
      double x = -size.height - tpX.width;
      double y = size.width - tpX.height/2 - (i * _lineChart.gridWidthStep);

//      final double r = sqrt(size.width * size.width + size.height * size.height) / 2;
//      final alpha = atan(size.height / size.width);
//      final beta = alpha + pi * 1.5;
//      final shiftY = r * sin(beta);
//      final shiftX = r * cos(beta);
//      final translateX = size.width / 2 - shiftX;
//      final translateY = size.height / 2 - shiftY;
//      canvas.translate(translateX, translateY);
      canvas.rotate(pi * 1.5);

      tpX.paint(
          canvas,
          Offset(x,
              y));
      canvas.restore();
      }


    }

    for (int i = 0; i < _lineChart.axisYValues.length; i++) {
      TextSpan span = TextSpan(
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w400, fontSize: 10),
          text: '${_lineChart.axisYValues[i]}');
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.right,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
          canvas,
          Offset(-tp.width - 5,
              (size.height - 6) - (i * _lineChart.gridHeightStep)));


    }
  }

  _drawHighlightPoint(Canvas canvas, Size size) {
    Point closestPoint =
        _lineChart.findClosest(Point(_tapPosition.dx, _tapPosition.dy), 0);

    Paint shadowPaint = Paint()
      ..color = Colors.black
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    //draw shadow
    canvas.drawCircle(Offset(closestPoint.x, closestPoint.y), 6, shadowPaint);

    Paint linePainter = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2
      ..color = Colors.blue;
    canvas.drawCircle(Offset(closestPoint.x, closestPoint.y), 5, linePainter);
    Paint lineHighLightPainter = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1
      ..color = Colors.blue;
    //draw highlight line
    canvas.drawLine(Offset(closestPoint.x, 0),
        Offset(closestPoint.x, size.height), lineHighLightPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return this._progress != 1 || _drawToolTip;
  }
}
