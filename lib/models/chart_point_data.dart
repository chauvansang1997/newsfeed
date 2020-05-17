class ChartPointData {
  final DateTime startTime;
  final int articles;
  final int accumulative;
  final String formattedAccumulative;
  final String formattedArticles;

  ChartPointData(this.startTime, this.articles, this.accumulative,
      this.formattedAccumulative, this.formattedArticles);

  factory ChartPointData.fromJson(json) {
    var startTime =
        new DateTime.fromMillisecondsSinceEpoch(json['startTime'] * 1000);
    int articles = json['articles'];
    int accumulative = json['accumulative'];
    String formattedAccumulative = json['formattedAccumulative'];
    String formattedArticles = json['formattedArticles'];

    return ChartPointData(startTime, articles, accumulative, formattedAccumulative,
        formattedArticles);
  }
}
