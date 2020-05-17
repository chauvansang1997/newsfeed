import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RelatedArticleScreen extends StatefulWidget {
  final String url;

  RelatedArticleScreen({Key key, this.url}) : super(key: key);

  @override
  _RelatedArticleScreenState createState() => _RelatedArticleScreenState();
}

class _RelatedArticleScreenState extends State<RelatedArticleScreen> {
  bool showWebView = false;

  @override
  void initState() {
    super.initState();
    afterLayout();
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
    return Scaffold(
      body: showWebView
          ? WebView(
              initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
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
