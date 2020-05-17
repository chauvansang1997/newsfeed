import 'dart:math';
import 'dart:ui';
import 'package:flutter/painting.dart';

class PathUtil {
  //distance that unit time can go
  final double _distance;

  //number of total point
  final int _numberPoint;

  final List<Point> _primaryPoints;

  List<Point> _path = [];

  PathUtil(this._distance, this._numberPoint, this._primaryPoints);

  static List<Path> createAnimatedPath(
      Path originalPath, double animationPercent, List<double> distances) {
    // ComputeMetrics can only be iterated once!
    final totalLength = originalPath
        .computeMetrics()
        .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);
    List<Path> paths = [];
    double currentLength = totalLength * animationPercent;
    double distance = 0;

    for(int i = 0; i< distances.length ; i++){
      if(currentLength > distances[i]){
          currentLength = (currentLength - distances[i]);
          Path path = _extractPathUntilLength(originalPath,distance, distance + distances[i]);
          paths.add(path);
          distance += distances[i];
      }
      else{
        Path path = _extractPathUntilLength(originalPath, distance, distance + currentLength);
        paths.add(path);


        break;
      }
    }
    if(paths.length == distances.length &&  animationPercent == 1){
      paths.add(Path());
    }

    return paths;
  }

  static Path _extractPathUntilLength(
      Path originalPath,
      double start,
      double length,
      ) {
    var currentLength = 0.0;

    final path = new Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(start, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        // There might be a more efficient way of extracting an entire path
        final pathSegment = metric.extractPath(start, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }

  void calculatePath() {
    double distancePerPoint = _distance / _numberPoint;
    _path.add(_primaryPoints[0]);

    double distanceCal = 0;
    for (int i = 1; i < _primaryPoints.length; i++) {
      Point currentPoint = _primaryPoints[i - 1];
      Point nextPoint = _primaryPoints[i];
      double distanceBetweenTwoPoint = sqrt(
          pow(nextPoint.x - currentPoint.x, 2) +
              pow(nextPoint.y - currentPoint.y, 2));
      distanceCal = 0;

      while (distanceBetweenTwoPoint > distanceCal) {
        distanceCal += distancePerPoint;
        double x = currentPoint.x +
            (distanceCal / distanceBetweenTwoPoint) *
                (nextPoint.x - currentPoint.x);
        double y = currentPoint.y +
            (distanceCal / distanceBetweenTwoPoint) *
                (nextPoint.y - currentPoint.y);

        if (distanceBetweenTwoPoint < distanceCal) {
          x = _primaryPoints[i].x.toDouble();
          y = _primaryPoints[i].y.toDouble();
        }

        _path.add(Point(x, y));
        if (_path.length == _numberPoint) {
          _path.removeLast();
          _path.add(Point(nextPoint.x, nextPoint.y));
          return;
        }
      }
    }
    return;
  }

  List<Point> getPathInProgress(double progress) {
    int number = (_numberPoint * progress).toInt();


    if (number == 0) {
      return [];
    }
    return _path.sublist(0, number);
  }

  List<Point> getIterationPoint(double progress) {
    double distancePerPoint = _distance / _numberPoint;
    if (progress == 0) {
      return [];
    }
    int number = (_numberPoint * progress).toInt();

    List<Point> points = [];
    points.add(_primaryPoints[0]);
    if (number == 1) {
      return points;
    }
    double distanceCal = 0;
    for (int i = 1; i < _primaryPoints.length; i++) {
      Point currentPoint = _primaryPoints[i - 1];
      Point nextPoint = _primaryPoints[i];
      double distanceBetweenTwoPoint = sqrt(
          pow(nextPoint.x - currentPoint.x, 2) +
              pow(nextPoint.y - currentPoint.y, 2));
      distanceCal = 0;

      while (distanceBetweenTwoPoint > distanceCal) {
        distanceCal += distancePerPoint;
        double x = currentPoint.x +
            (distanceCal / distanceBetweenTwoPoint) *
                (nextPoint.x - currentPoint.x);
        double y = currentPoint.y +
            (distanceCal / distanceBetweenTwoPoint) *
                (nextPoint.y - currentPoint.y);

        if (distanceBetweenTwoPoint < distanceCal) {
          x = _primaryPoints[i].x.toDouble();
          y = _primaryPoints[i].y.toDouble();
        }

        points.add(Point(x, y));
        if (points.length == number) {
          return points;
        }
      }
    }
    return points;
  }
}
