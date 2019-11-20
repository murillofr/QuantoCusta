import 'dart:async';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class PerfilPage extends StatefulWidget {
  final int page;
  final GlobalKey bottomNavigationKey;

  const PerfilPage({Key key, this.page, this.bottomNavigationKey})
      : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  double coordX = 0.0;
  Duration animationDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
  }

  void didUpdateWidget(PerfilPage oldWidget) {
    setState(() {
      if (widget.page == 1) {
        if (widget.page != oldWidget.page) {
          if (coordX == 0.0) {
            animationDuration = Duration(milliseconds: 0);
            coordX = oldWidget.page == 0
                ? MediaQuery.of(context).size.width
                : -MediaQuery.of(context).size.width;

            Timer(Duration(milliseconds: 1), () {
              setState(() => {
                    animationDuration = Duration(milliseconds: 200),
                    coordX = 0.0,
                  });
            });
          } else {
            animationDuration = Duration(milliseconds: 200);
            coordX = 0.0;
          }
        }
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final CurvedNavigationBarState navBarState =
        widget.bottomNavigationKey.currentState;
    return AnimatedContainer(
      duration: animationDuration,
      transform: Matrix4.translationValues(coordX, 0.0, 0.0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                color: Colors.blueAccent,
                child: Text('ACESSAR PAGE 0'),
                onPressed: () {
                  navBarState.setPage(0);
                },
              ),
              MaterialButton(
                color: Colors.blueAccent,
                child: Text('ACESSAR PAGE 2'),
                onPressed: () {
                  navBarState.setPage(2);
                },
              ),
              MaterialButton(
                color: Colors.blueAccent,
                child: Text('ACESSAR PAGE 3'),
                onPressed: () {
                  navBarState.setPage(3);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
