import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:newsfeed/utility/const.dart';

import 'chart_line.dart';

class LineChart {
  Map<int, Path> _pathCache = Map();

  final List<ChartLine> _chartLines;

  final int _stepXGrid;
  final int _stepYGrid;

  final double _fromValue;

  double _gridHeightStep;

  double _gridWidthStep;

//

  final int _type;

  List<String> _axisXValues;

  List<String> _axisYValues;

  Map<int, List<double>> _mapDistances;

  Map<int, List<Point>> _mapPoints;

  Map<int, List<Alignment>> _mapAlignmentStart;

  Map<int, List<Alignment>> _mapAlignmentEnd;

  List<ChartLine> get chartLines => _chartLines;

  int get stepXGrid => _stepXGrid;

  int get stepYGrid => _stepYGrid;

  List<String> get axisXValues => _axisXValues;

  List<String> get axisYValues => _axisYValues;

  double get gridHeightStep => _gridHeightStep;

  double get gridWidthStep => _gridWidthStep;

  List<Alignment> alignmentStart(int index) => _mapAlignmentStart[index];

  List<Alignment> alignmentEnd(int index) => _mapAlignmentEnd[index];

  List<double> distances(int index) => _mapDistances[index];

  LineChart(
    this._chartLines,
    this._stepXGrid,
    this._stepYGrid,
    this._type,
    this._fromValue,
  );

  //width : width of widget
  //height : height of widget
  void scaleChart(double width, double height) {
    _gridHeightStep = height / _stepYGrid;
    _gridWidthStep = width / _stepXGrid;
    _axisXValues = [];
    _axisYValues = [];

    double minX = 0;
    double minY = 0;
    double maxX = 0;
    double maxY = 0;
    _mapPoints = Map();

    _chartLines.forEach((line) {
      if (minX > line.minX) {
        minX = line.minX;
      }

      if (minY > line.minY) {
        minY = line.minY;
      }

      if (maxX < line.maxX) {
        maxX = line.maxX;
      }

      if (maxY < line.maxY) {
        maxY = line.maxY;
      }
    });

//    double ratioPoint = (maxX - minX) / (maxY - minY);
//    double ratioWidget = width / height;
    double widthPoint = maxX - minX;
    double heightPoint = maxY - minY;
//    double newHeight = width * (ratioWidget);
    for (int i = 0; i < _stepYGrid + 1; i++) {
      _axisYValues
          .add((minY + (heightPoint / _stepXGrid) * i).toStringAsFixed(2));
    }
    bool sameYear = DateTime.fromMillisecondsSinceEpoch(
                ((_fromValue + (widthPoint / _stepXGrid) * 0)).toInt())
            .year ==
        DateTime.fromMillisecondsSinceEpoch(
                ((_fromValue + (widthPoint / _stepXGrid) * _stepXGrid)).toInt())
            .year;
    for (int i = 0; i < _stepXGrid + 1; i++) {
      if (_type == 0) {
        _axisXValues.add((_fromValue + minX + (widthPoint / _stepXGrid) * i)
            .toStringAsFixed(2));
//        _axisYValues.add((minY + (heightPoint / _stepXGrid) * i).toString());
      } else {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(
            ((_fromValue + (widthPoint / _stepXGrid) * i)).toInt());
        if (sameYear) {

          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              ((_fromValue + (widthPoint / _stepXGrid) * i)).toInt());
          _axisXValues.add(Const.dateMonthWeekFormat.format(date) +
              ' at ' +
              Const.hourFormat.format(date));

        } else {
          _axisXValues.add(Const.dateYearWeekFormat.format(date)  );
        }

//        _axisYValues.add((minY + (heightPoint / _stepXGrid) * i).toString());
      }
    }
    for (int i = 0; i < _chartLines.length; i++) {
      _mapPoints[i] = [];
      _chartLines[i].primaryPoints.forEach((point) {
        //we change location t
        double x = ((point.x / maxX)) * width;
        //change origin from top left to bottom left
        double y = height - (point.y / maxY) * height;

        _mapPoints[i].add(Point(x, y));
      });
    }
    _mapDistances = Map();
    _mapAlignmentStart = Map();
    _mapAlignmentEnd = Map();

    _chartLines.forEach((line) {
      int index = _chartLines.indexOf(line);
      _mapDistances[index] = [];
      _mapAlignmentStart[index] = [];
      _mapAlignmentEnd[index] = [];
      for (int i = 1; i < _mapPoints[index].length; i++) {
        _mapDistances[index]
            .add(_mapPoints[index][i - 1].distanceTo(_mapPoints[index][i]));

        double x1, x2, y1, y2;
        x1 = (_mapPoints[index][i].x - _mapPoints[index][i - 1].x);
        x1 = x1 > 0 ? 1 : x1 < 0 ? -1 : 0;
        x2 = (_mapPoints[index][i - 1].x - _mapPoints[index][i].x);
        x2 = x2 > 0 ? 1 : x2 < 0 ? -1 : 0;

        y1 = (_mapPoints[index][i - 1].y - _mapPoints[index][i].y);
        y1 = y1 > 0 ? 1 : y1 < 0 ? -1 : 0;

        y2 = (_mapPoints[index][i].y - _mapPoints[index][i - 1].y);
        y2 = y2 > 0 ? 1 : y2 < 0 ? -1 : 0;

        if (_mapPoints[index][i].x > _mapPoints[index][i - 1].x &&
            _mapPoints[index][i].y < _mapPoints[index][i - 1].y) {
          _mapAlignmentStart[index].add(Alignment(-1, 1));
          _mapAlignmentEnd[index].add(Alignment(1, -1));
        }
        if (x1 == 0 && x2 == 0) {
          _mapAlignmentStart[index].add(Alignment(x1, y1));
          _mapAlignmentEnd[index].add(Alignment(x2, y2));
        } else {
          _mapAlignmentStart[index].add(Alignment(x2, y2));
          _mapAlignmentEnd[index].add(Alignment(x1, y1));
        }
      }
    });
  }

  Point findClosest(Point point, int lineIndex) {
    Point candidate = _mapPoints[lineIndex][0];
    double candidateDist = point.distanceTo(candidate);

    for (Point alternative in _mapPoints[lineIndex]) {
      double alternativeDist = point.distanceTo(alternative);
      if (alternativeDist < candidateDist) {
        candidate = alternative;
        candidateDist = point.distanceTo(candidate);
      }
//      if (alternativeDist > candidateDist) {
//        break;
//      }
    }
    return candidate;
  }

  Path getPathCache(int index) {
    if (_pathCache.containsKey(index)) {
      return _pathCache[index];
    }

    Path path = Path();
    bool init = true;

    this._mapPoints[index].forEach((p) {
      if (init) {
        init = false;
        path.moveTo(p.x.toDouble(), p.y.toDouble());
      }

      path.lineTo(p.x.toDouble(), p.y.toDouble());
    });
    _pathCache[index] = path;

    return path;
  }
}
