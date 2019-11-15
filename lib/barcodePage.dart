import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BarcodePage extends StatefulWidget {
  final String resultBarcode;
  final String inOutScan;
  final int page;
  final GlobalKey bottomNavigationKey;

  const BarcodePage(
      {Key key,
      this.resultBarcode,
      this.inOutScan,
      this.page,
      this.bottomNavigationKey})
      : super(key: key);

  @override
  _BarcodePageState createState() => _BarcodePageState();
}

const List<String> _photoData = const [
  "assets/bing.png",
  "assets/google.png",
  "assets/youtube.jpg",
];

class _BarcodePageState extends State<BarcodePage> {
  double coordX = 0.0;
  Duration animationDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
  }

  int _coverPhoto = 0;

  void didUpdateWidget(BarcodePage oldWidget) {
    setState(() {
      if (widget.page == 2) {
        if (widget.page != oldWidget.page) {
          if (coordX == 0.0) {
            animationDuration = Duration(milliseconds: 0);
            coordX = oldWidget.page == 3
                ? -MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width;
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
        } else {
          // Verifica se é a primeira vez que o scan está sendo chamado
          if (oldWidget.inOutScan == 'in' && widget.inOutScan == 'out') {
            _switchCoverPhoto();
          } else {}
        }
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  void _switchCoverPhoto() {
    setState(() {
      _coverPhoto++;
      if (_coverPhoto == _photoData.length) {
        _coverPhoto = 0;
      }
    });
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
        body: ListView(
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              height: 200,
                              color: Colors.white,
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Visibility(
                                    visible: widget.resultBarcode == '',
                                    child: Container(
                                      child: Text('LOGO DO APP'),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.resultBarcode != '',
                                    child: Flexible(
                                      child: Image(
                                        image:
                                            AssetImage(_photoData[_coverPhoto]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
                        child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.end,
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
                              child: Text('ACESSAR PAGE 3'),
                              onPressed: () {
                                navBarState.setPage(3);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    width: widget.resultBarcode == '' ? 0 : null,
                    margin: EdgeInsets.only(top: 178.0),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.yellow[200],
                          width: 5.0,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                        color: Colors.yellow[200],
                      ),
                      child: Text(
                        widget.resultBarcode,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
