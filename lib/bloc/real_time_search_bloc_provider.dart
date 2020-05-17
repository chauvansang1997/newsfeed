import 'package:flutter/cupertino.dart';
import 'package:newsfeed/bloc/realtime_search_bloc.dart';

class RealTimeSearchBlocProvider extends InheritedWidget {
  final RealtimeSearchBloc bloc;

  RealTimeSearchBlocProvider({Key key, Widget child})
      : bloc = RealtimeSearchBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static RealtimeSearchBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RealTimeSearchBlocProvider>()
        .bloc;
  }
}
