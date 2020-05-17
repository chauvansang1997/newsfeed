import 'article.dart';
import 'chart_point_data.dart';

class RealTimeSearch {
  final String title;

  final String timeRange;

  final DateTime timestamp;

  final List<Article> articles;

  final List<ChartPointData> chartPoints;

  RealTimeSearch(this.title, this.timeRange, this.timestamp, this.articles, this.chartPoints);
}
