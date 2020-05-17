import 'dart:math';
import 'dart:ui';


import 'package:newsfeed/models/chart_line.dart';

class Dates {
  final DateTime min;
  final DateTime max;

  Dates(this.min, this.max);
}

class DateTimeSeriesConverter {
  static List<ChartLine> convertFromDateMaps(
      List<Map<DateTime, double>> series,
      List<Color> primaryColors,
      List<Color> highLightColors) {
    Dates minMax = _findMinMax(series);

    int index = 0;
    List<ChartLine> lines = series
        .map((map) =>
            _convert(map, minMax, primaryColors[index], highLightColors[index]))
        .toList();

    return lines;
  }

  static ChartLine _convert(Map<DateTime, double> input, Dates minMax,
      Color primaryColor, Color highLightColor) {
    DateTime from = minMax.min;
//    Dates minMax = _findMinMax(series);
    List<Point> result = [];

    input.forEach((dateTime, value) {
      double x = dateTime.difference(from).inSeconds.toDouble();
      double y = value;

      result.add(Point(x, y));
    });

    return ChartLine(result, primaryColor, highLightColor);
  }

  static Dates _findMinMax(List<Map<DateTime, double>> list) {
    DateTime min;
    DateTime max;

    list.forEach((map) {
      map.keys.forEach((dateTime) {
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
    });

    return Dates(min, max);
  }
}
