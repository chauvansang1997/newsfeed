import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/models/trend_search.dart';
import 'package:newsfeed/presentation/custom_icons.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:math' as math;
import 'article_widget.dart';

class TrendSearchWidget extends StatefulWidget {
  final TrendSearch trendSearch;
  final int index;

  const TrendSearchWidget({Key key, this.trendSearch, this.index})
      : super(key: key);

  @override
  _TrendSearchWidgetState createState() => _TrendSearchWidgetState();
}

class _TrendSearchWidgetState extends State<TrendSearchWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _rotateAnimation;
  Animation<double> _heightAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }
  @override
  void didUpdateWidget(TrendSearchWidget oldWidget) {
    if(_controller.value == 1){
      _controller.reverse();
    }
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    _rotateAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _heightAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _rotateAnimation =
        Tween(begin: 0.0, end: -math.pi).animate(_rotateAnimation);
    _heightAnimation =
        Tween(begin: 120.0, end: 270.0 ).animate(_heightAnimation);

    TrendSearch trendSearch = widget.trendSearch;

    return Container(
      height: _heightAnimation.value,
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
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              child: Row(
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
                  SizedBox(
                    width: 15 * screenWidth / 360,
                  ),
                  Container(
                      width: 130 * screenWidth / 360,
                      child: Text(
                        '${trendSearch.title}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 16 * screenWidth / 360,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      )),
                  Container(
                    width: 80 * screenWidth / 360,
                    child: Text(
                      '${trendSearch.formattedTraffic}',
                      style: TextStyle(
                        fontSize: 16 * screenWidth / 360,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  LinearPercentIndicator(
                    width: 50.0,
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 20,
                    leading: Container(),
                    trailing: Container(),
                    percent: ((100 / 5) * trendSearch.hotLevel) / 100,
                    center: Container(),
                    linearStrokeCap: LinearStrokeCap.butt,
                    progressColor: Colors.red,
                  ),
                  SizedBox(
                    width: 10* screenWidth / 360,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_controller.isCompleted) {
                        _controller.reverse();
                      } else {
                        _controller.forward();
                      }
                    },
                    child: Transform.rotate(
                      child: Icon(CustomIcons.up_open),
                      angle: _rotateAnimation.value,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 135 * screenHeight / 780,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: trendSearch.articles.length,
                separatorBuilder: (BuildContext context, int index) {
                  return ArticleWidget(
                    tag: 'trend_search$index${trendSearch.articles[index].title}',
                    article: trendSearch.articles[index],
                    callback: (){
                      Navigator.pushNamed(context, '/relatedArticle',
                          arguments: trendSearch.articles[index].url);
                    },
                    width: screenWidth - 28* screenWidth / 360,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox();
                },
              ),

            )
          ],
        ),
      ),
    );
  }
}
