import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsfeed/bloc/home_screen_bloc.dart';

class SideDrawer extends StatelessWidget {
  final HomeScreenBloc homeScreenBloc;
  const SideDrawer({
    Key key, this.homeScreenBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = 227 * screenWidth / 375;
    double maxApsect = screenWidth / 375;
    maxApsect = maxApsect > 1 ? 1 : maxApsect;
    return Container(
      width: width, //20.0,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor:
              Colors.blue, //This will change the drawer background to blue.
          //other styles
        ),
        child: Drawer(
            child: Container(
          color: Color(0XFFEFEFEF),
          child: SafeArea(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: <Widget>[
                  Container(
                    width: width,
                    height: 1,
                    color: Color(0XFFC3C3C3),
                  ),
                  Container(
                    width: width,
                    height: 1,
                    color: Colors.white,
                  ),
                  GestureDetector(
                    onTap: (){
                      homeScreenBloc.changeNewsMode();
                    },
                    child: Container(
                      height: 45,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 22*maxApsect,),
                            Text(
                              'Change news mode',
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  color: Color.fromARGB(
                                      255, 83, 83, 83),
                                  fontSize:
                                  15 *maxApsect,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Futura'),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    height: 1,
                    color: Color(0XFFC3C3C3),
                  ),

                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
