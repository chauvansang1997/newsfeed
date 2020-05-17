import 'dart:convert';
import 'package:newsfeed/api/Constants.dart';
import 'package:newsfeed/models/article.dart';
import 'package:http/http.dart' as http;
import 'package:newsfeed/models/chart_point_data.dart';
import 'package:newsfeed/models/daily_trend_search_data.dart';
import 'package:newsfeed/models/realtime_search.dart';
import 'package:sprintf/sprintf.dart';

class Api {
//  Future<http.Response> _executeGet(String url,
//      {List<dynamic> parameters, Map<String, dynamic> headers}) async {
//    url = sprintf(url, parameters);
//    http.Response response = await http.get(url, headers: headers);
//    return response;
//  }

  static Future<List<Article>> getTrendArticles(
      List<String> ids, String category) async {
    //combine all id to parameter
    String formatIDs = "";
    for (int i = 0; i < ids.length; i++) {
      formatIDs += "id=" + ids[i] + "&";
    }
    //print(formatIDs);

    //remove last "&"
    formatIDs = formatIDs.substring(0, formatIDs.length - 1);

    String url =
        sprintf(Constants.TRENDING_SUMMARY_URL, ["vi-VN", category, formatIDs]);
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String result = response.body.substring(4, response.body.length);
      Map<String, dynamic> decoded = json.decode(result);
      List<Article> articles = [];
      for (int i = 0; i < decoded['trendingStories'].length; i++) {
        articles.add(Article.fromJson(decoded['trendingStories'][i]));
      }
      return articles;
    } else {
      throw Exception('Failed to connect to server');
    }
  }

  static Future<List<Article>> getRelatedArticles(String id) async {
    String url = sprintf(Constants.RELATED_ARTICLE_URL, [id, "vi-VN"]);
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String result = response.body.substring(4, response.body.length);
      Map<String, dynamic> decoded = json.decode(result);
      var related = decoded['widgets'][0]['articles'];
      List<Article> articles = [];
      for (int i = 0; i < related.length; i++) {
        articles.add(Article.fromJson(related[i], type: 2));
      }
      return articles;
    } else {
      throw Exception('Failed to connect to server');
    }
  }

  static Future<RealTimeSearch> getRealTimeSearch(String id) async {
    String url = sprintf(Constants.RELATED_ARTICLE_URL, [id, "vi-VN"]);
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String result = response.body.substring(4, response.body.length);
      Map<String, dynamic> decoded = json.decode(result);
      var related = decoded['widgets'][0]['articles'];
      List<Article> articles = [];
      if(related != null){
        for (int i = 0; i < related.length; i++) {
          articles.add(Article.fromJson(related[i], type: 2));
        }
      }

      List<ChartPointData> chartPoints = [];
      var barData = decoded['widgets'][1]['barData'];
      if(barData != null){
        for (int i = 0; i < barData.length; i++) {
          chartPoints.add(ChartPointData.fromJson(barData[i]));
        }
      }

      var time =
      new DateTime.fromMillisecondsSinceEpoch(decoded['timestamp'] * 1000);
      RealTimeSearch realTimeSearch = RealTimeSearch(decoded['title'],
          decoded['timeRange'],time, articles, chartPoints);
      return realTimeSearch;
    } else {
      print(id);
      return null;
    }

  }

  static Future<List<String>> getArticlesId(String category) async {
    String url = sprintf(Constants.GOOGLE_TREND_URL, ["vi-VN", category, "VN"]);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String result = response.body.substring(4, response.body.length);
      Map<String, dynamic> decoded = json.decode(result);
      List<String> ids = [];
      for (int i = 0; i < decoded['trendingStoryIds'].length; i++) {

        ids.add(decoded['trendingStoryIds'][i]);
      }
      return ids;
    } else {
      throw Exception('Failed to connect to server');
    }
  }

  static Future<DailyTrendSearchData> getTrendSearchData(String date) async {
    String url =
        sprintf(Constants.DAILY_TREND_SEARCH_URL, ['vi-VN', date, 'VN']);
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String result = response.body.substring(5, response.body.length);
      Map<String, dynamic> decoded = json.decode(result);

      DailyTrendSearchData data =
          DailyTrendSearchData.fromJson(decoded['default']);
      return data;
    } else {
      throw Exception('Failed to connect to server');
    }
  }
}
