import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/bloc/realtime_search_bloc.dart';
import 'package:newsfeed/ui/widgets/realtime_search_tab.dart';

class TendencyPage extends StatefulWidget {
  @override
  _TendencyPageState createState() => _TendencyPageState();
}

class _TendencyPageState extends State<TendencyPage>
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
    realTimeSearchBloc.fetchRealtimeSearches(_tabController.index);

    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  void _handleTabSelection() {
    realTimeSearchBloc.fetchRealtimeSearches(_tabController.index);
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
          RealTimeSearchTab(
            tabIndex: 0,
          ),
          RealTimeSearchTab(
            tabIndex: 1,
          ),
          RealTimeSearchTab(
            tabIndex: 2,
          ),
          RealTimeSearchTab(
            tabIndex: 3,
          ),
          RealTimeSearchTab(
            tabIndex: 4,
          ),
          RealTimeSearchTab(
            tabIndex: 5,
          ),
        ],
        controller: _tabController,
      ),
    );
  }
}
