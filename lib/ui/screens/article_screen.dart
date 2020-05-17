import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/bloc/article_bloc_provider.dart';
import 'package:newsfeed/bloc/related_article_bloc.dart';
import 'package:newsfeed/models/article.dart';
import 'package:newsfeed/ui/widgets/article_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatefulWidget {
  final Article article;

  const ArticleScreen({Key key, this.article}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<ArticleScreen> {
  RelatedArticleBloc bloc;
  bool showWebView = false;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    afterLayout();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    bloc.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    bloc = ArticleBlocProvider.of(context);
    bloc.fetchRelatedArticles(widget.article.id);
    super.didChangeDependencies();
  }

  void afterLayout() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        showWebView = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: showWebView
          ? Stack(
              children: <Widget>[
                WebView(
                  initialUrl: widget.article.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
                Positioned(
                  bottom: 0,
                  child: StreamBuilder(
                    stream: bloc.relatedArticles,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Article>> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: screenWidth,
                          height: 135 * screenHeight / 780,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox();
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return ArticleWidget(
                                article: snapshot.data[index],
                                callback: () {
                                  Navigator.pushNamed(
                                      context, '/relatedArticle',
                                      arguments: snapshot.data[index].url);
                                },
                                tag: 'article$index${widget.article.id}',
                              );
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                )
              ],
            )
          : Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.cyan,
                  strokeWidth: 5,
                ),
              ),
            ),
    );
  }
}
