import 'package:flutter/cupertino.dart';
import 'daily_trend_bloc.dart';

class TrendSearchBlocProvider extends InheritedWidget {
  final DailyTrendBloc bloc;

  TrendSearchBlocProvider({Key key, Widget child})
      : bloc = DailyTrendBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static DailyTrendBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TrendSearchBlocProvider>()
        .bloc;
  }
}
