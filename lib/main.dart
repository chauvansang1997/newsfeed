import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsfeed/ui/screens/article_screen.dart';
import 'package:newsfeed/ui/screens/home_screen.dart';
import 'package:newsfeed/ui/screens/related_article_screen.dart';

import 'bloc/article_bloc_provider.dart';
import 'bloc/home_screen_bloc_provider.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      builder: (context, child) {
        return child;
      },
      title: 'News',
      onGenerateRoute: (settings) {
        final name = settings.name;
        print(name);
        final paths = name.split('/');
        if (paths[0] != '') {
          return null;
        }
        switch (paths[1]) {
          case 'home':
            return MaterialPageRoute(
                builder: (context) {
                  return HomeScreenBlocProvider(child: HomeScreen());
                },
                settings: RouteSettings(name: "/home"));
          case 'article':
            return MaterialPageRoute(
                builder: (context) {
                  return ArticleBlocProvider(
                      child: ArticleScreen(
                    article: settings.arguments,
                  ));
                },
                settings: RouteSettings(name: "/home"));

          case 'relatedArticle':
            return MaterialPageRoute(
                builder: (context) {
                  return RelatedArticleScreen(
                    url: settings.arguments,
                  );
                },
                settings: RouteSettings(name: "/relatedArticle"));

            break;
          default:
            return null;
        }
      },
      initialRoute: '/home',
    );
  }
}
