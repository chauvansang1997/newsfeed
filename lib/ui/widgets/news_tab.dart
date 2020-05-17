import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/bloc/article_bloc.dart';
import 'package:newsfeed/models/article.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'article_widget.dart';

class NewsTab extends StatefulWidget {
  final int tabIndex;

  const NewsTab({Key key, this.tabIndex}) : super(key: key);

  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab>
    with AutomaticKeepAliveClientMixin<NewsTab> {
  Widget content;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    articleBloc.refresh.listen((value) {
      if (value) {
        _refreshController.refreshCompleted();
      }
    });
    articleBloc.loadMore.listen((value) {
      if (value) {
        _refreshController.loadComplete();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: articleBloc.articleFetchers[widget.tabIndex],
      builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
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
              articleBloc.refreshArticles(widget.tabIndex);
            },
            onLoading: () async {
              articleBloc.fetchNextArticles(widget.tabIndex);
            },
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 0,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                Article article = snapshot.data[index];

                return ArticleWidget(
                  article: article,
                  callback: () {
                    Navigator.pushNamed(context, '/article',
                        arguments: article);
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
  @mustCallSuper
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
