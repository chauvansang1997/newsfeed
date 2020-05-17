import 'package:flutter/material.dart';

class LineDrawModel {
  final Offset from;
  final Offset to;

  LineDrawModel(this.from, this.to);
}

class LinePainter extends CustomPainter {
  final Color _color;
  final double _strokeWidth;
  final LineDrawModel _lineDrawModel;

  LinePainter(this._color, this._strokeWidth, this._lineDrawModel);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = _color;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = this._strokeWidth;
    canvas.drawLine(_lineDrawModel.from, _lineDrawModel.to, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}

class LinesPainter extends CustomPainter {
  final Color _color;
  final double _strokeWidth;
  final List<LineDrawModel> _lines;

  LinesPainter(this._color, this._strokeWidth, this._lines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = _color;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = this._strokeWidth;
    _lines.forEach((line){
      canvas.drawLine(line.from, line.to, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}