import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final Color _color;
  final double _strokeWidth;

  CirclePainter(this._color, this._strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = _color;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = this._strokeWidth;
    paint.isAntiAlias = true;
    var center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width/2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}