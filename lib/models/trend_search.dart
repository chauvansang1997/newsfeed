import 'article.dart';

class TrendSearch {
  final String title;
  final String formattedTraffic;
  final int hotLevel;
  final List<Article> articles;


  TrendSearch(this.title, this.articles, this.formattedTraffic, this.hotLevel);

  factory TrendSearch.fromJson(json) {
    List<Article> articles = [];
    String title = json['title']['query'];
    String formattedTraffic = json['formattedTraffic'];
    int hotLevel = 1;
    final intRegex = RegExp(r'\s+(\d+)\s+', multiLine: true);
    if (formattedTraffic.contains('N')) {
      int number = int.parse(
          intRegex.allMatches(formattedTraffic).map((m) => m.group(0)).first);
      if (number >= 500) {
        hotLevel = 4;
      } else if (number >= 100) {
        hotLevel = 3;
      } else if (number >= 20) {
        hotLevel = 2;
      }
    } else {
      hotLevel = 5;
    }
    for (int i = 0; i < json['articles'].length; i++) {
      Article article = Article.fromJson(json['articles'][i], type: 3);
      articles.add(article);
    }
    return TrendSearch(title, articles, formattedTraffic, hotLevel);
  }
}
