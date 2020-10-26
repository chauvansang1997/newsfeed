import 'package:newsfeed/api/Constants.dart';
import 'package:newsfeed/models/daily_trend_search.dart';
import 'package:newsfeed/models/daily_trend_search_data.dart';
import 'package:newsfeed/repositories/google_repository.dart';
import 'package:rxdart/rxdart.dart';

class DailyTrendBloc {
  final _googleRepository = GoogleRepository();
  final _trendSearchFetcher = BehaviorSubject<DailyTrendSearchData>();

  BehaviorSubject<bool> _loadMoreFetcher = BehaviorSubject<bool>();
  BehaviorSubject<bool> _refreshFetcher = BehaviorSubject<bool>();

  DailyTrendSearchData _dailyTrendSearchData;
  String endDateForNextRequest = '';
  Stream<bool> get loadMore => _loadMoreFetcher.stream;

  Stream<bool> get refresh => _refreshFetcher.stream;
  Stream<DailyTrendSearchData> get trendSearchArticles =>
      _trendSearchFetcher.stream;

  void dispose() {
    _trendSearchFetcher.close();
    _loadMoreFetcher.close();
    _refreshFetcher.close();
  }

  Future<void> fetchTrendingSearches() async {
    _refreshFetcher.sink.add(false);
    String date = Constants.dateFormat.format(DateTime.now());
    var dailyTrendSearchData =
        await _googleRepository.fetchTrendSearchData(date);
    _dailyTrendSearchData = dailyTrendSearchData;
    _trendSearchFetcher.sink.add(dailyTrendSearchData);
    _refreshFetcher.sink.add(true);
  }
  Future<void> refreshTrendingSearches() async {
    _refreshFetcher.sink.add(false);
    var dailyTrendSearchData =
    await _googleRepository.fetchTrendSearchData(_dailyTrendSearchData.endDateForNextRequest);
    _dailyTrendSearchData = dailyTrendSearchData;
    _trendSearchFetcher.sink.add(dailyTrendSearchData);
    _refreshFetcher.sink.add(true);
  }
  Future<void> fetchNextTrendingSearches() async {
    _loadMoreFetcher.sink.add(false);
    var dailyTrendSearchData =
        await _googleRepository.fetchTrendSearchData(_dailyTrendSearchData.endDateForNextRequest);

    List<DailyTrendSearch> dailyTrendSearches = [];
    dailyTrendSearches.addAll(_dailyTrendSearchData.dailyTrendSearch);
    dailyTrendSearches.addAll(dailyTrendSearchData.dailyTrendSearch);
    _dailyTrendSearchData = DailyTrendSearchData(dailyTrendSearchData.endDateForNextRequest,
        dailyTrendSearches );

    _trendSearchFetcher.sink.add(_dailyTrendSearchData);
    _loadMoreFetcher.sink.add(true);
  }
}

