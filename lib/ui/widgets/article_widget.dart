import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/models/article.dart';

class ArticleWidget extends StatelessWidget {
  final GestureTapCallback callback;
  final Article article;
  final String tag;
  final double width;

  const ArticleWidget({Key key, this.callback, this.article, this.tag = '', this.width = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: callback,
      child: Padding(
        padding: EdgeInsets.all(5.0* screenWidth / 360),
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
          width:  width == 0 ? screenWidth : width,
          height: 130 * screenHeight / 780,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 11,
                child: Container(
                  width: 125 * screenWidth / 360,
                  height: 130 * screenHeight / 780,
                  decoration: article.image != null
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(article.image),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5)),
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5)),
                        ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: SizedBox(width: 5 * screenWidth / 360)),
              Expanded(
                flex: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: SizedBox(height: 5)
                    ),
                    Expanded(
                      flex: 33,
                      child: Container(
                        //height: 100 * screenHeight / 780,
                        child: Text(
                          article.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: TextStyle(
                            fontSize: 14 * screenWidth / 360,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Container(
                              width: 140 * screenWidth / 360,
                              child: Text(
                                article.source,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11 * screenWidth / 360,
                                  color: Colors.teal,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              article.time,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10 * screenWidth / 360,
                                color: Colors.black54,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
