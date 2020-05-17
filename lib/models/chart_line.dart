import 'dart:math';
import 'dart:ui';

class ChartLine {
  final List<Point> _primaryPoints;

  final Color _primaryColor;

  final Color _highLightColor;

  double _minX;
  double _minY;
  double _maxX;
  double _maxY;

  double get minX => _minX;

  double get minY => _minY;

  double get maxX => _maxX;

  double get maxY => _maxY;

  List<Point> get primaryPoints => _primaryPoints;

  Color get primaryColor => _primaryColor;

  Color get highLightColor => _highLightColor;

  ChartLine(this._primaryPoints, this._primaryColor, this._highLightColor) {
    _getMaxArea();
  }

  scalePoints() {}

  _getMaxArea() {
    _minX = 0;
    _minY = 0;
    _maxX = 0;
    _maxY = 0;
    primaryPoints.forEach((point) {
      if (_minX > point.x) {
        _minX = point.x.toDouble();
      }

      if (_minY > point.y) {
        _minY = point.y.toDouble();
      }

      if (_maxX < point.x) {
        _maxX = point.x.toDouble();
      }

      if (_maxY < point.y) {
        _maxY = point.y.toDouble();
      }
    });
  }
}
