import 'package:newsfeed/models/article.dart';
import 'package:newsfeed/repositories/google_repository.dart';
import 'package:rxdart/rxdart.dart';

class ArticleBloc {
  final _googleRepository = GoogleRepository();

  List<BehaviorSubject<List<Article>>> articleFetchers;

  BehaviorSubject<bool> _loadMoreFetcher;

  BehaviorSubject<bool> _refreshFetcher;

  Observable<bool> get loadMore => _loadMoreFetcher.stream;

  Observable<bool> get refresh => _refreshFetcher.stream;

  Map<String, List<String>> _mapArticleIdType;

  Map<String, List<Article>> _mapArticleInfoType;

  Map<String, int> _mapCurrentArticlesIndex;

  List<String> _tabNames;

  final int _numberFetch = 15;

  Future<void> dispose() async {
    for (var fetcher in articleFetchers) {
      fetcher.close();
    }
    _refreshFetcher.close();
    _loadMoreFetcher.close();
  }

  ArticleBloc() {
    _tabNames = List<String>();
    _tabNames.add('b');
    _tabNames.add('e');
    _tabNames.add('m');
    _tabNames.add('t');
    _tabNames.add('s');
    _tabNames.add('h');

    _loadMoreFetcher = BehaviorSubject<bool>();
    _refreshFetcher = BehaviorSubject<bool>();
    articleFetchers = new List<BehaviorSubject<List<Article>>>();
    _mapArticleIdType = Map<String, List<String>>();
    _mapArticleInfoType = Map<String, List<Article>>();
    _mapCurrentArticlesIndex = Map<String, int>();

    for (int i = 0; i < _tabNames.length; i++) {
      BehaviorSubject<List<Article>> fetcher = BehaviorSubject<List<Article>>();
      articleFetchers.add(fetcher);
      _mapArticleInfoType.putIfAbsent(_tabNames[i], () => List());
      _mapArticleIdType.putIfAbsent(_tabNames[i], () => List());
      _mapCurrentArticlesIndex.putIfAbsent(_tabNames[i], () => 0);
    }
  }

  refreshArticles(int indexCategory) {
    _refreshFetcher.sink.add(false);
    String category = _tabNames[indexCategory];
    _mapArticleIdType[category].clear();
    _mapCurrentArticlesIndex[category] = 0;
    fetchArticles(indexCategory);
    _refreshFetcher.sink.add(true);
  }

  fetchNextArticles(int indexCategory) async {
    _loadMoreFetcher.sink.add(false);
    String category = _tabNames[indexCategory];
    int startIndex = _mapCurrentArticlesIndex[category];
    int endIndex = _mapCurrentArticlesIndex[category] + _numberFetch;
    if (startIndex >= _mapArticleIdType[category].length - 1) {
      _loadMoreFetcher.sink.add(true);
      return;
    }

    startIndex += 1;

    if (endIndex > _mapArticleIdType[category].length - 1) {
      endIndex = _mapArticleIdType[category].length - 1;
    }

    if (startIndex == endIndex) {
      _loadMoreFetcher.sink.add(true);
      return;
    }

    List<Article> articles = await _googleRepository.fetchArticlesInfo(
        _mapArticleIdType[category].sublist(startIndex, endIndex), category);

    _mapArticleInfoType[category].addAll(articles);

    articleFetchers[indexCategory].sink.add(_mapArticleInfoType[category]);

    _mapCurrentArticlesIndex[category] = endIndex;

    _loadMoreFetcher.sink.add(true);
  }

  fetchArticles(int indexCategory) async {
    String category = _tabNames[indexCategory];
    if (_mapArticleIdType[category].length == 0) {
      _mapArticleIdType[category] =
          await _googleRepository.fetchAllStoriesId(category);
      int endIndex = _mapCurrentArticlesIndex[category] + _numberFetch;
      int startIndex = 0;

      if (endIndex > _mapArticleIdType[category].length - 1) {
        endIndex = _mapArticleIdType[category].length - 1;
      }
      if (startIndex == endIndex) {
        return;
      }
      _mapArticleInfoType[category] = await _googleRepository.fetchArticlesInfo(
          _mapArticleIdType[category].sublist(startIndex, endIndex), category);

      articleFetchers[indexCategory].sink.add(_mapArticleInfoType[category]);

      _mapCurrentArticlesIndex[category] = endIndex;
    }
  }
}

final articleBloc = ArticleBloc();
