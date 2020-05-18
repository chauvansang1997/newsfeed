import 'package:newsfeed/api/api.dart';
import 'package:newsfeed/models/article.dart';
import 'package:newsfeed/models/daily_trend_search_data.dart';
import 'package:newsfeed/models/realtime_search.dart';

class GoogleRepository {

  Future<List<Article>> fetchArticlesInfo(List<String> ids, String category) =>
      Api.getTrendArticles(ids, category);

  Future<List<Article>> fetchRelatedArticles(String id) =>
      Api.getRelatedArticles(id);

  Future<List<String>> fetchAllStoriesId(String category) =>
      Api.getArticlesId(category);

  Future<RealTimeSearch> fetchRealTimeSearch(String id) =>
      Api.getRealTimeSearch(id);

  Future<DailyTrendSearchData> fetchTrendSearchData(String date) =>
      Api.getTrendSearchData(date);
}
