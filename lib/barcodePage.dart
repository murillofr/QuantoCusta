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
  "assets/cajuba.png",
  "assets/omo.png",
  "assets/qualy.png",
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
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            // A fixed-height child.
                            color: const Color(0xff808000), // Yellow
                            height: 200.0,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        30.0, 19.0, 30.0, 41.0),
                                    height: 200,
                                    color: Colors.white,
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                              image: AssetImage(
                                                  _photoData[_coverPhoto]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 5.0, 8.0, 5.0),
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
                      Expanded(
                        // A flexible child that will grow to fit the viewport but
                        // still be at least as big as necessary to fit its contents.
                        child: Container(
                          color: const Color(0xff800000), // Red
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
                                  child: Text('ACESSAR PAGE 3'),
                                  onPressed: () {
                                    navBarState.setPage(3);
                                  },
                                ),
                                MaterialButton(
                                  color: Colors.blueAccent,
                                  child: Text('ACESSAR PAGE 3'),
                                  onPressed: () {
                                    navBarState.setPage(3);
                                  },
                                ),
                                MaterialButton(
                                  color: Colors.blueAccent,
                                  child: Text('ACESSAR PAGE 3'),
                                  onPressed: () {
                                    navBarState.setPage(3);
                                  },
                                ),
                                MaterialButton(
                                  color: Colors.blueAccent,
                                  child: Text('ACESSAR PAGE 3'),
                                  onPressed: () {
                                    navBarState.setPage(3);
                                  },
                                ),
                                MaterialButton(
                                  color: Colors.blueAccent,
                                  child: Text('ACESSAR PAGE 3'),
                                  onPressed: () {
                                    navBarState.setPage(3);
                                  },
                                ),
                                MaterialButton(
                                  color: Colors.blueAccent,
                                  child: Text('ACESSAR PAGE 3'),
                                  onPressed: () {
                                    navBarState.setPage(3);
                                  },
                                ),
                                MaterialButton(
                                  color: Colors.blueAccent,
                                  child: Text('ACESSAR PAGE 3'),
                                  onPressed: () {
                                    navBarState.setPage(3);
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
