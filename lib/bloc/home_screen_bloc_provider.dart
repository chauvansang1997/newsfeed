import 'package:flutter/cupertino.dart';
import 'home_screen_bloc.dart';

class HomeScreenBlocProvider extends InheritedWidget {
  final HomeScreenBloc bloc;

  HomeScreenBlocProvider({Key key, Widget child})
      : bloc = HomeScreenBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static HomeScreenBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeScreenBlocProvider>()
        .bloc;
  }
}
