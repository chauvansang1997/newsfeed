import 'daily_trend_search.dart';

class DailyTrendSearchData {
  final String endDateForNextRequest;
  final List<DailyTrendSearch> dailyTrendSearch;

  DailyTrendSearchData(this.endDateForNextRequest, this.dailyTrendSearch);

  factory DailyTrendSearchData.fromJson(json) {
    List<DailyTrendSearch> dailyTrendSearches = [];
    for (int i = 0; i < json['trendingSearchesDays'].length; i++) {
      DailyTrendSearch dailyTrendSearch =
          DailyTrendSearch.fromJson(json['trendingSearchesDays'][i]);
      dailyTrendSearches.add(dailyTrendSearch);
    }
    return DailyTrendSearchData(
        json['endDateForNextRequest'], dailyTrendSearches);
  }
}
