import 'package:newsfeed/models/article.dart';
import 'package:newsfeed/repositories/google_repository.dart';
import 'package:rxdart/rxdart.dart';

class RelatedArticleBloc{
  final _googleRepository = GoogleRepository();
  final _articlesFetcher = BehaviorSubject<List<Article>>();

  Stream<List<Article>> get relatedArticles => _articlesFetcher.stream;


  void dispose(){
    _articlesFetcher.close();
  }

  Future<void> fetchRelatedArticles(String id) async {
    var articles = await _googleRepository.fetchRelatedArticles(id);
    articles.removeAt(0);
    _articlesFetcher.sink.add(articles);
  }

}