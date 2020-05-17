import 'package:newsfeed/models/trend_search.dart';

class DailyTrendSearch {
  final DateTime date;
  final String formattedDate;
  final List<TrendSearch> trendSearches;

  DailyTrendSearch(this.date, this.formattedDate, this.trendSearches);

  factory DailyTrendSearch.fromJson(json) {
    List<TrendSearch> trendSearches = [];
    DateTime date;
    String formattedDate;
    print(json['date']);
    date = DateTime.parse(json['date']);
    formattedDate = json['formattedDate'];
    for (int i = 0; i < json['trendingSearches'].length; i++) {
      TrendSearch article = TrendSearch.fromJson(json['trendingSearches'][i]);
      trendSearches.add(article);
    }
    return DailyTrendSearch(date, formattedDate, trendSearches);
  }
}
