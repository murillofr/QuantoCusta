import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class ListaProdutosPage extends StatefulWidget {
  final int page;
  final int pageAntiga;
  final String controleTransicao;
  final GlobalKey bottomNavigationKey;

  const ListaProdutosPage(
      {Key key,
      this.page,
      this.pageAntiga,
      this.controleTransicao,
      this.bottomNavigationKey})
      : super(key: key);

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  double coordX = 0.0;
  Duration animationDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
  }

  void didUpdateWidget(ListaProdutosPage oldWidget) {
    setState(() {
      if (widget.page == 3) {
        if (widget.page != oldWidget.page) {
          if (coordX == 0.0) {
            animationDuration = Duration(milliseconds: 0);
            coordX = widget.pageAntiga != 0
                ? MediaQuery.of(context).size.width
                : widget.controleTransicao == 'TAP'
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
                child: Text('ACESSAR PAGE 1'),
                onPressed: () {
                  navBarState.setPage(1);
                },
              ),
              MaterialButton(
                color: Colors.blueAccent,
                child: Text('ACESSAR PAGE 2'),
                onPressed: () {
                  navBarState.setPage(2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
