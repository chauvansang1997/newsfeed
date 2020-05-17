import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/models/line_chart.dart';
import 'package:newsfeed/models/realtime_search.dart';
import 'package:newsfeed/presentation/custom_icons.dart';
import 'package:newsfeed/utility/chart_point_converter.dart';

import 'animated_graph.dart';
import 'article_widget.dart';

class RealTimeSearchWidget extends StatefulWidget {
  final GestureTapCallback callback;
  final RealTimeSearch realTimeSearch;
  final String tag;
  final double width;
  final int index;

  const RealTimeSearchWidget(
      {Key key,
      this.callback,
      this.realTimeSearch,
      this.tag = '',
      this.width = 0,
      this.index})
      : super(key: key);

  @override
  _RealTimeSearchWidgetState createState() => _RealTimeSearchWidgetState();
}

class _RealTimeSearchWidgetState extends State<RealTimeSearchWidget>
    with SingleTickerProviderStateMixin {
  bool reset = false;
  AnimationController _controller;
  Animation<double> _rotateAnimation;
  Animation<double> _heightAnimation;
  LineChart _lineChart;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.addListener(() {
      setState(() {});
    });
    List data = ChartPointSeriesConverter.convertFromData(
        [widget.realTimeSearch.chartPoints], [Colors.blue], [Colors.red]);
    _lineChart = LineChart(data[0], 3, 5, 1, data[1].toDouble());

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RealTimeSearchWidget oldWidget) {
    if (_controller.value == 1) {
      _controller.reverse();
    }
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
//    final screenHeight = MediaQuery.of(context).size.height;

    _rotateAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _heightAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _rotateAnimation = Tween(begin: 0.0, end: -pi).animate(_rotateAnimation);
    _heightAnimation = Tween(begin: 80.0, end: 350.0).animate(_heightAnimation);

    return Padding(
      padding: EdgeInsets.all(5.0 * screenWidth / 360),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.black54, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 3.0, // has the effect of softening the shadow
              spreadRadius: 2.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                2.0, // vertical, move down 10
              ),
            )
          ],
        ),
        width: widget.width == 0 ? screenWidth : widget.width,
        height: _heightAnimation.value,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 5 * screenWidth / 360,
                    ),
                    Container(
                      width: 20 * screenWidth / 360,
                      child: Text(
                        '${widget.index + 1}',
                        style: TextStyle(
                          fontSize: 16 * screenWidth / 360,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 290 * screenWidth / 360,
                      child: Center(
                        child: Text(
                          widget.realTimeSearch.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 10 * screenWidth / 360,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_controller.isCompleted) {
                          reset = false;
                          _controller.reverse();
                        } else {
                          reset = true;
                          _controller.forward();
                        }
                      },
                      child: Transform.rotate(
                        child: Icon(CustomIcons.up_open),
                        angle: _rotateAnimation.value,
                      ),
                    ),
                  ]),
              Padding(
                child: Container(
                  height: 100,
                  child: AnimatedGraph(
                    resetAnimation: reset,
                    lineChart: _lineChart,
                  ),
                ),
                padding: EdgeInsets.only(left: 40, right: 40),
              ),
              SizedBox(height: 30,),
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.realTimeSearch.articles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ArticleWidget(
                      width: screenWidth,
                      callback: (){
                        Navigator.pushNamed(context, '/relatedArticle',
                            arguments: widget.realTimeSearch.articles[index].url);
                      },
                      article: widget.realTimeSearch.articles[index],
                      tag:
                          'tendency${widget.realTimeSearch.articles[index].title}',
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
