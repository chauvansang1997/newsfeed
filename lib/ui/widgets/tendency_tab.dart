import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/bloc/realtime_search_bloc.dart';
import 'package:newsfeed/models/realtime_search.dart';
import 'package:newsfeed/ui/widgets/realtime_search_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TendencyTab extends StatefulWidget {
  final int tabIndex;

  const TendencyTab({Key key, this.tabIndex}) : super(key: key);

  @override
  _TendencyTabState createState() => _TendencyTabState();
}

class _TendencyTabState extends State<TendencyTab>
    with AutomaticKeepAliveClientMixin<TendencyTab> {
  Widget content;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    realTimeSearchBloc.refresh.listen((value){
      if(value){
        _refreshController.refreshCompleted();
      }
    });
    realTimeSearchBloc.loadMore.listen((value){
      if(value){
        _refreshController.loadComplete();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: realTimeSearchBloc.realTimeSearchFetchers[widget.tabIndex],
      builder: (BuildContext context, AsyncSnapshot<List<RealTimeSearch>> snapshot) {
        if (snapshot.hasData) {
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
              realTimeSearchBloc.refreshRealtimeSearches(widget.tabIndex);
            },
            onLoading: () async {
              print("load");
              realTimeSearchBloc.fetchNextRealtimeSearches(widget.tabIndex);

            },
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 0,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                RealTimeSearch realTimeSearch = snapshot.data[index];

                return RealTimeSearchWidget(
                  realTimeSearch: realTimeSearch,
                  index: index,

                  callback: () {
//                    Navigator.pushNamed(context, '/article',
//                        arguments: realTimeSearch);
                  },
                );
              },
              itemCount: snapshot.data.length,
            ),
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
