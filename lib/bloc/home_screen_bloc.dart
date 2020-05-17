import 'package:rxdart/rxdart.dart';

enum NewsMode { News, KeyWord }

class HomeScreenBloc {
  BehaviorSubject<NewsMode> _changeNewsModeFetcher;

  Observable<NewsMode> get mode => _changeNewsModeFetcher.stream;
  NewsMode _newsMode = NewsMode.News;

  Future<void> dispose() async {
    _changeNewsModeFetcher.close();
  }

  HomeScreenBloc() {
    _changeNewsModeFetcher = BehaviorSubject<NewsMode>();
  }

  void changeNewsMode() {
    if (_newsMode == NewsMode.News) {
      _newsMode = NewsMode.KeyWord;
    } else {
      _newsMode = NewsMode.News;
    }
    _changeNewsModeFetcher.sink.add(_newsMode);
  }
}
