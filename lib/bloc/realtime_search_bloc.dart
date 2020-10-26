import 'dart:async';
import 'dart:core';

import 'package:newsfeed/models/realtime_search.dart';
import 'package:newsfeed/repositories/google_repository.dart';
import 'package:rxdart/rxdart.dart';

class RealtimeSearchBloc {
  final _googleRepository = GoogleRepository();

  List<BehaviorSubject<List<RealTimeSearch>>> realTimeSearchFetchers;

  BehaviorSubject<bool> _loadMoreFetcher;

  BehaviorSubject<bool> _refreshFetcher;

  Stream<bool> get loadMore => _loadMoreFetcher.stream;

  Stream<bool> get refresh => _refreshFetcher.stream;

  Map<String, List<String>> _mapIdType;

  Map<String, List<RealTimeSearch>> _mapRealTimeSearchInfoType;

  Map<String, int> _mapCurrentRealTimeSearchIndex;

  List<String> _tabNames;

  final int _numberFetch = 5;

  Future<void> dispose() async {
    for (var fetcher in realTimeSearchFetchers) {
      fetcher.close();
    }
    _refreshFetcher.close();
    _loadMoreFetcher.close();
  }

  RealtimeSearchBloc() {
    _tabNames = List<String>();
    _tabNames.add('b');
    _tabNames.add('e');
    _tabNames.add('m');
    _tabNames.add('t');
    _tabNames.add('s');
    _tabNames.add('h');

    _loadMoreFetcher = BehaviorSubject<bool>();
    _refreshFetcher = BehaviorSubject<bool>();
    realTimeSearchFetchers = new List<BehaviorSubject<List<RealTimeSearch>>>();
    _mapIdType = Map<String, List<String>>();
    _mapRealTimeSearchInfoType = Map<String, List<RealTimeSearch>>();
    _mapCurrentRealTimeSearchIndex = Map<String, int>();
    for (int i = 0; i < _tabNames.length; i++) {
      BehaviorSubject<List<RealTimeSearch>> fetcher =
          BehaviorSubject<List<RealTimeSearch>>();
      realTimeSearchFetchers.add(fetcher);
      _mapRealTimeSearchInfoType.putIfAbsent(_tabNames[i], () => List());
      _mapIdType.putIfAbsent(_tabNames[i], () => List());
      _mapCurrentRealTimeSearchIndex.putIfAbsent(_tabNames[i], () => 0);
    }
  }

  refreshRealtimeSearches(int indexCategory) {
    _refreshFetcher.sink.add(false);
    String category = _tabNames[indexCategory];
    _mapIdType[category].clear();
    _mapCurrentRealTimeSearchIndex[category] = 0;
    fetchRealtimeSearches(indexCategory);
    _refreshFetcher.sink.add(true);
  }

  fetchNextRealtimeSearches(int indexCategory) async {
    _loadMoreFetcher.sink.add(false);
    String category = _tabNames[indexCategory];
    int startIndex = _mapCurrentRealTimeSearchIndex[category];
    int endIndex = _mapCurrentRealTimeSearchIndex[category] + _numberFetch;
    if (startIndex >= _mapIdType[category].length - 1) {
      _loadMoreFetcher.sink.add(true);
      return;
    }

    startIndex += 1;

    if (endIndex > _mapIdType[category].length - 1) {
      endIndex = _mapIdType[category].length - 1;
    }

    if (startIndex == endIndex) {
      _loadMoreFetcher.sink.add(true);
      return;
    }

    List<RealTimeSearch> realTimeSearches = [];
    List<String> subIds = _mapIdType[category].sublist(startIndex, endIndex);
    for (int i = 0; i < subIds.length; i++) {
      RealTimeSearch realTimeSearch =
          await _googleRepository.fetchRealTimeSearch(subIds[i]);
      if (realTimeSearch != null) {
        realTimeSearches.add(realTimeSearch);
      }
    }

    print(realTimeSearches.length);
    _mapRealTimeSearchInfoType[category].addAll(realTimeSearches);

    realTimeSearchFetchers[indexCategory]
        .sink
        .add(_mapRealTimeSearchInfoType[category]);

    _mapCurrentRealTimeSearchIndex[category] = endIndex;
    _loadMoreFetcher.sink.add(true);
  }

  fetchRealtimeSearches(int indexCategory) async {
    String category = _tabNames[indexCategory];
    if (_mapIdType[category].length == 0) {
      _mapIdType[category] =
          await _googleRepository.fetchAllStoriesId(category);
      int endIndex = _mapCurrentRealTimeSearchIndex[category] + _numberFetch;
      int startIndex = 0;
      if (endIndex > _mapIdType[category].length - 1) {
        endIndex = _mapIdType[category].length - 1;
      }
      if (startIndex == endIndex) {
        return;
      }
      List<RealTimeSearch> realTimeSearches = [];
      List<String> subIds = _mapIdType[category].sublist(startIndex, endIndex);
      for (int i = 0; i < subIds.length; i++) {
        RealTimeSearch realTimeSearch =
            await _googleRepository.fetchRealTimeSearch(subIds[i]);
        if (realTimeSearch != null) {
          realTimeSearches.add(realTimeSearch);
        }
      }

      _mapRealTimeSearchInfoType[category].addAll(realTimeSearches);
      realTimeSearchFetchers[indexCategory]
          .sink
          .add(_mapRealTimeSearchInfoType[category]);
      _mapCurrentRealTimeSearchIndex[category] = endIndex;
    }
  }
}

final realTimeSearchBloc = RealtimeSearchBloc();
