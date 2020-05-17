import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/bloc/daily_trend_bloc.dart';
import 'package:newsfeed/bloc/trend_search_bloc_provider.dart';
import 'package:newsfeed/models/daily_trend_search.dart';
import 'package:newsfeed/ui/widgets/trend_search_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DailyTrendWidget extends StatefulWidget {
  final List<DailyTrendSearch> dailyTrendSearches;

  const DailyTrendWidget({Key key, this.dailyTrendSearches}) : super(key: key);

  @override
  _DailyTrendWidgetState createState() => _DailyTrendWidgetState();
}

class _DailyTrendWidgetState extends State<DailyTrendWidget> {
  DailyTrendBloc bloc;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    bloc = TrendSearchBlocProvider.of(context);
    bloc.refresh.listen((value){
      if(value){
        _refreshController.refreshCompleted();
      }
    });
    bloc.loadMore.listen((value){
      if(value){
        _refreshController.loadComplete();
      }
    });
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<DailyTrendSearch> dailyTrendSearches = widget.dailyTrendSearches;
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: ClassicHeader(),
      footer:
      CustomFooter(builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text("pull up load");
        } else if (mode == LoadStatus.loading) {
          body = CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = Text("Load Failed!Click retry!");
        } else if (mode == LoadStatus.canLoading) {
          body = Text("release to load more");
        } else {
          body = Text("No more Data");
        }
        return Container(
          height: 55.0,
          child: Center(child: body),
        );
      }),
      controller: _refreshController,
      onRefresh: () async {
        print("onRefresh");
        bloc.fetchTrendingSearches();
      },
      onLoading: () async {
        print("load");
        bloc.fetchNextTrendingSearches();

      },
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 30,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '${dailyTrendSearches[index].formattedDate}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ] +
                  dailyTrendSearches[index]
                      .trendSearches
                      .map((item) => Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              TrendSearchWidget(
                                trendSearch: item,
                                index: dailyTrendSearches[index]
                                    .trendSearches
                                    .indexOf(item),
                              ),
                            ],
                          ))
                      .toList(),
            ),
            padding: EdgeInsets.only(left: 10 , right: 10),
          );
        },
        itemCount: dailyTrendSearches.length,
      ),
    );
  }
}
