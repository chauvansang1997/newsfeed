import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/bloc/article_bloc.dart';

import 'news_tab.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void dispose() {
    // TODO: implement dispose
    print("dispose");
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    _tabController = new TabController(length: 6, vsync: this);
    articleBloc.fetchArticles(_tabController.index);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  void _handleTabSelection() {
    articleBloc.fetchArticles(_tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(
                child: Text("Business"),
              ),
              Tab(
                child: Text("Entertainment"),
              ),
              Tab(
                child: Text("Heath"),
              ),
              Tab(
                child: Text("Sci/Tech"),
              ),
              Tab(
                child: Text("Sports"),
              ),
              Tab(
                child: Text("Top stories"),
              )
            ],
          ),
        ),
        preferredSize: Size.fromHeight(50.0),
      ),
      body: TabBarView(
        children: [
          NewsTab(
            tabIndex: 0,
          ),
          NewsTab(
            tabIndex: 1,
          ),
          NewsTab(
            tabIndex: 2,
          ),
          NewsTab(
            tabIndex: 3,
          ),
          NewsTab(
            tabIndex: 4,
          ),
          NewsTab(
            tabIndex: 5,
          ),
        ],
        controller: _tabController,
      ),
    );
  }
}
