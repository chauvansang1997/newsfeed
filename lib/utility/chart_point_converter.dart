import 'dart:math';
import 'dart:ui';

import 'package:newsfeed/models/chart_line.dart';
import 'package:newsfeed/models/chart_point_data.dart';

class Dates {
  final DateTime min;
  final DateTime max;

  Dates(this.min, this.max);
}

class ChartPointSeriesConverter {
  static List convertFromData(List<List<ChartPointData>> series,
      List<Color> primaryColors, List<Color> highLightColors) {
    Dates minMax = _findMinMax(series);

    int index = 0;
    List<ChartLine> lines = series
        .map((map) =>
            _convert(map, minMax, primaryColors[index], highLightColors[index]))
        .toList();

    return [lines, minMax.min.millisecondsSinceEpoch];
  }

  static ChartLine _convert(List<ChartPointData> input, Dates minMax,
      Color primaryColor, Color highLightColor) {
    DateTime from = minMax.min;
//    Dates minMax = _findMinMax(series);
    List<Point> result = [];

    input.forEach((value) {
      double x = (value.startTime.millisecondsSinceEpoch - from.millisecondsSinceEpoch).toDouble();
      double y = value.accumulative.toDouble();

      result.add(Point(x, y));
    });

    return ChartLine(result, primaryColor, highLightColor);
  }

  static Dates _findMinMax(List<List<ChartPointData>> list) {
    DateTime min;
    DateTime max;

    list.forEach((map) {
      map.forEach((value) {
        DateTime dateTime = value.startTime;
        if (min == null) {
          min = dateTime;
          max = dateTime;
        } else {
          if (dateTime.isBefore(min)) {
            min = dateTime;
          }
          if (dateTime.isAfter(max)) {
            max = dateTime;
          }
        }
      });

//      map.keys.forEach((dateTime) {
//
//      });
    });

    return Dates(min, max);
  }
}
