import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:newsfeed/bloc/daily_trend_bloc.dart';
import 'package:newsfeed/bloc/trend_search_bloc_provider.dart';
import 'package:newsfeed/models/daily_trend_search_data.dart';

import 'daily_trend_widget.dart';

class DailyTrendPage extends StatefulWidget {
  @override
  _DailyTrendPageState createState() => _DailyTrendPageState();
}

class _DailyTrendPageState extends State<DailyTrendPage> {
  DailyTrendBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    bloc = TrendSearchBlocProvider.of(context);
    bloc.fetchTrendingSearches();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
//    final screenWidth = MediaQuery.of(context).size.width;
//    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
    backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: bloc.trendSearchArticles  ,
        builder:
            (BuildContext context, AsyncSnapshot<DailyTrendSearchData> snapshot) {
          if (snapshot.hasData) {
            return DailyTrendWidget(
              dailyTrendSearches: snapshot.data.dailyTrendSearch,
            );
          } else {
            return Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.cyan,
                  strokeWidth: 5,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
