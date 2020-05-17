import 'package:flutter/cupertino.dart';
import 'package:newsfeed/bloc/related_article_bloc.dart';

class ArticleBlocProvider extends InheritedWidget {
  final RelatedArticleBloc bloc;

  ArticleBlocProvider({Key key, Widget child})
      : bloc = RelatedArticleBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static RelatedArticleBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ArticleBlocProvider>()
        .bloc;
  }
}
