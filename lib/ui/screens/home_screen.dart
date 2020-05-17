import 'package:flutter/material.dart';
import 'package:newsfeed/bloc/trend_search_bloc_provider.dart';
import 'package:newsfeed/presentation/custom_icons.dart';
import 'package:newsfeed/ui/widgets/daily_trend_page.dart';
import 'package:newsfeed/ui/widgets/news_page.dart';
import 'package:newsfeed/ui/widgets/tendency_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // TabController _tabController;
  int _currentIndex = 0;

//  NewsMode _newsMode = NewsMode.News;
  PageController _controller = PageController(
    initialPage: 0,
  );

//  HomeScreenBloc _homeScreenBloc;

  @override
  void dispose() {
    // TODO: implement dispose
    print("dispose");
//    articleBloc.dispose();
    // realTimeSearchBloc.dispose();
    // _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    //  _tabController = new TabController(length: 6, vsync: this);
//    articleBloc.fetchArticles(_tabController.index);
    //realTimeSearchBloc.fetchRealtimeSearches(_tabController.index);
    // _tabController.addListener(_handleTabSelection);
    super.initState();
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
//    _homeScreenBloc = HomeScreenBlocProvider.of(context);
//
//    _homeScreenBloc.mode.listen((value) {
//      setState(() {
//        _newsMode = value;
//      });
//    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
//    final screenWidth = MediaQuery.of(context).size.width;
//    final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: PageView(
          scrollDirection: Axis.horizontal,
          controller: _controller,
          children: <Widget>[
//            Scaffold(
//              drawer: SideDrawer(
//                homeScreenBloc: _homeScreenBloc,
//              ),
//              appBar: PreferredSize(
//                child: AppBar(
//                  bottom: TabBar(
//                    controller: _tabController,
//                    isScrollable: true,
//                    tabs: [
//                      Tab(
//                        child: Text("Business"),
//                      ),
//                      Tab(
//                        child: Text("Entertainment"),
//                      ),
//                      Tab(
//                        child: Text("Heath"),
//                      ),
//                      Tab(
//                        child: Text("Sci/Tech"),
//                      ),
//                      Tab(
//                        child: Text("Sports"),
//                      ),
//                      Tab(
//                        child: Text("Top stories"),
//                      )
//                    ],
//                  ),
//                ),
//                preferredSize: Size.fromHeight(50.0),
//              ),
//              body: TabBarView(
//                children: _newsMode == NewsMode.News
//                    ? [
//                        NewsTab(
//                          tabIndex: 0,
//                        ),
//                        NewsTab(
//                          tabIndex: 1,
//                        ),
//                        NewsTab(
//                          tabIndex: 2,
//                        ),
//                        NewsTab(
//                          tabIndex: 3,
//                        ),
//                        NewsTab(
//                          tabIndex: 4,
//                        ),
//                        NewsTab(
//                          tabIndex: 5,
//                        ),
//                      ]
//                    : [
//                        RealTimeSearchTab(
//                          tabIndex: 0,
//                        ),
//                        RealTimeSearchTab(
//                          tabIndex: 1,
//                        ),
//                        RealTimeSearchTab(
//                          tabIndex: 2,
//                        ),
//                        RealTimeSearchTab(
//                          tabIndex: 3,
//                        ),
//                        RealTimeSearchTab(
//                          tabIndex: 4,
//                        ),
//                        RealTimeSearchTab(
//                          tabIndex: 5,
//                        ),
//                      ],
//                controller: _tabController,
//              ),
//            ),
            NewsPage(),
            TrendSearchBlocProvider(child: DailyTrendPage()),
            TendencyPage()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _controller.animateToPage(index,
                duration: Duration(milliseconds: 800), curve: Curves.easeInOut);
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black45,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  CustomIcons.newspaper,
                ),
                title: Text("News")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                title: Text("Search")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.trending_up,
                ),
                title: Text("Tendency")),
          ],
        ),
      ),
    );
  }
}
