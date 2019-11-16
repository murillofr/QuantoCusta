import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quanto_custa/alertPage.dart';
import 'package:quanto_custa/perfilPage.dart';
import 'package:quanto_custa/barcodePage.dart';
import 'package:quanto_custa/scanPage.dart';
import 'package:quanto_custa/listaProdutosPage.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:swipedetector/swipedetector.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final Duration animationDuration = Duration(milliseconds: 400);
final Duration delay = Duration(milliseconds: 0);

void main() => runApp(
      MaterialApp(
        home: HomePage(),
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
      ),
    );

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _page = 2;
  int _pageAntiga = 2;
  String _controleTransicao = '';
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;
  bool _fabVisible = true;
  String _resultBarcode = '';
  String inOutScan = '';
  double coordX = 0.0;
  Duration animationDurationFloatingButton = Duration(milliseconds: 200);
  DragStartDetails startHorizontalDragDetails;
  DragUpdateDetails updateHorizontalDragDetails;
  double initial;
  double distance;
  double percentage = 0.0;

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _portraitModeOnly();
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Container(
            color: Colors.yellow[200],
            child: SafeArea(
              child: Container(
                margin: _page == 0
                    ? const EdgeInsets.only(bottom: 16.0)
                    : _page == 1
                        ? const EdgeInsets.only(bottom: 16.0)
                        : _page == 2
                            ? EdgeInsets.only(bottom: 66.0)
                            : const EdgeInsets.only(bottom: 16.0),
                child: _switcherBody(),
              ),
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: 2,
            height: 60.0,
            color: Colors.blueAccent,
            buttonBackgroundColor: Colors.blueAccent,
            backgroundColor: Colors.yellow[200],
            animationCurve: Curves.decelerate,
            animationDuration: Duration(milliseconds: 300),
            items: <Widget>[
              Padding(
                padding: _page == 0
                    ? const EdgeInsets.all(1.4)
                    : const EdgeInsets.only(top: 10.0),
                child: Icon(Icons.error_outline, size: 30),
              ),
              Padding(
                padding: _page == 1
                    ? const EdgeInsets.all(1.4)
                    : const EdgeInsets.only(top: 10.0),
                child: Icon(Icons.person_outline, size: 30),
              ),
              Padding(
                padding: _page == 2
                    ? const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 3.0)
                    : const EdgeInsets.only(top: 10.0),
                child: Icon(CommunityMaterialIcons.barcode_scan, size: 30),
              ),
              Padding(
                padding: _page == 3
                    ? const EdgeInsets.fromLTRB(1.1, 0.0, 1.1, 3.5)
                    : const EdgeInsets.only(top: 10.0),
                child: Icon(CommunityMaterialIcons.clipboard_text_outline,
                    size: 30),
              ),
            ],
            onTap: (index) {
              setState(() {
                if (_page != index) {
                  _pageAntiga = _page;
                  _page = index;
                  _controleTransicao = 'TAP';

                  if (_page == 2) {
                    if ((_pageAntiga == 0 && _page == 2) ||
                        ((_pageAntiga == 1 && _page == 2))) {
                      animationDurationFloatingButton =
                          Duration(milliseconds: 0);
                      _fabVisible = false;
                      coordX = MediaQuery.of(context).size.width;

                      Timer(Duration(milliseconds: 50), () {
                        setState(() => {
                              animationDurationFloatingButton =
                                  Duration(milliseconds: 200),
                              _fabVisible = true,
                              coordX = 0.0,
                            });
                      });
                    }
                    if (_pageAntiga == 3 && _page == 2) {
                      animationDurationFloatingButton =
                          Duration(milliseconds: 0);
                      _fabVisible = false;
                      coordX = -MediaQuery.of(context).size.width;

                      Timer(Duration(milliseconds: 50), () {
                        setState(() => {
                              animationDurationFloatingButton =
                                  Duration(milliseconds: 200),
                              _fabVisible = true,
                              coordX = 0.0,
                            });
                      });
                    }
                  } else {
                    _fabVisible = false;
                  }
                }
              });
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: AnimatedContainer(
              duration: animationDurationFloatingButton,
              transform: Matrix4.translationValues(coordX, 0.0, 0.0),
              child: Visibility(
                visible: _fabVisible,
                child: RectGetter(
                  key: rectGetterKey,
                  child: FloatingActionButton.extended(
                    label: Text('ESCANEAR CÓDIGO DE BARRAS'),
                    onPressed: _onTapScan,
                    elevation: 0,
                    backgroundColor: Colors.black,
                  ),
                ),
              )),
        ),
        _ripple(),
      ],
    );
  }

  Widget _switcherBody() {
    return Stack(
      children: <Widget>[
        Offstage(
          offstage: _page != 0,
          child: TickerMode(
            enabled: _page == 0,
            child: OnlyOnePointerRecognizerWidget(
              child: SwipeDetector(
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: AlertPage(
                      page: _page,
                      pageAntiga: _pageAntiga,
                      controleTransicao: _controleTransicao,
                      bottomNavigationKey: _bottomNavigationKey),
                ),
                onSwipeLeft: () {
                  final CurvedNavigationBarState navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState.setPage(1);
                  setState(() {
                    _controleTransicao = 'SLIDE';
                  });
                },
                onSwipeRight: () {
                  final CurvedNavigationBarState navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState.setPage(3);
                  setState(() {
                    _controleTransicao = 'SLIDE';
                  });
                },
                swipeConfiguration: SwipeConfiguration(
                    verticalSwipeMinVelocity: 300.0,
                    verticalSwipeMinDisplacement: 100.0,
                    verticalSwipeMaxWidthThreshold: 50.0,
                    horizontalSwipeMaxHeightThreshold: 50.0,
                    horizontalSwipeMinDisplacement: 30.0,
                    horizontalSwipeMinVelocity: 50.0),
              ),
            ),
          ),
        ),
        Offstage(
          offstage: _page != 1,
          child: TickerMode(
            enabled: _page == 1,
            child: OnlyOnePointerRecognizerWidget(
              child: SwipeDetector(
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: PerfilPage(
                    page: _page,
                    bottomNavigationKey: _bottomNavigationKey,
                  ),
                ),
                onSwipeLeft: () {
                  final CurvedNavigationBarState navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState.setPage(2);
                  setState(() {
                    _controleTransicao = 'SLIDE';
                  });
                },
                onSwipeRight: () {
                  final CurvedNavigationBarState navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState.setPage(0);
                  setState(() {
                    _controleTransicao = 'SLIDE';
                  });
                },
                swipeConfiguration: SwipeConfiguration(
                    verticalSwipeMinVelocity: 300.0,
                    verticalSwipeMinDisplacement: 100.0,
                    verticalSwipeMaxWidthThreshold: 50.0,
                    horizontalSwipeMaxHeightThreshold: 50.0,
                    horizontalSwipeMinDisplacement: 30.0,
                    horizontalSwipeMinVelocity: 50.0),
              ),
            ),
          ),
        ),
        Offstage(
          offstage: _page != 2,
          child: TickerMode(
            enabled: _page == 2,
            child: OnlyOnePointerRecognizerWidget(
              child: SwipeDetector(
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: BarcodePage(
                    resultBarcode: '$_resultBarcode',
                    inOutScan: '$inOutScan',
                    page: _page,
                    bottomNavigationKey: _bottomNavigationKey,
                  ),
                ),
                onSwipeLeft: () {
                  final CurvedNavigationBarState navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState.setPage(3);
                  setState(() {
                    _controleTransicao = 'SLIDE';
                  });
                },
                onSwipeRight: () {
                  final CurvedNavigationBarState navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState.setPage(1);
                  setState(() {
                    _controleTransicao = 'SLIDE';
                  });
                },
                swipeConfiguration: SwipeConfiguration(
                    verticalSwipeMinVelocity: 300.0,
                    verticalSwipeMinDisplacement: 100.0,
                    verticalSwipeMaxWidthThreshold: 50.0,
                    horizontalSwipeMaxHeightThreshold: 50.0,
                    horizontalSwipeMinDisplacement: 30.0,
                    horizontalSwipeMinVelocity: 50.0),
              ),
            ),
          ),
        ),
        Offstage(
          offstage: _page != 3,
          child: TickerMode(
            enabled: _page == 3,
            child: OnlyOnePointerRecognizerWidget(
              child: SwipeDetector(
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: ListaProdutosPage(
                    page: _page,
                    pageAntiga: _pageAntiga,
                    controleTransicao: _controleTransicao,
                    bottomNavigationKey: _bottomNavigationKey,
                  ),
                ),
                onSwipeLeft: () {
                  final CurvedNavigationBarState navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState.setPage(0);
                  setState(() {
                    _controleTransicao = 'SLIDE';
                  });
                },
                onSwipeRight: () {
                  final CurvedNavigationBarState navBarState =
                      _bottomNavigationKey.currentState;
                  navBarState.setPage(2);
                  setState(() {
                    _controleTransicao = 'SLIDE';
                  });
                },
                swipeConfiguration: SwipeConfiguration(
                    verticalSwipeMinVelocity: 300.0,
                    verticalSwipeMinDisplacement: 100.0,
                    verticalSwipeMaxWidthThreshold: 50.0,
                    horizontalSwipeMaxHeightThreshold: 50.0,
                    horizontalSwipeMinDisplacement: 30.0,
                    horizontalSwipeMinVelocity: 50.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void didPopNext() {
    setState(
      () {
        setState(() =>
            rect = rect.deflate(1.3 * MediaQuery.of(context).size.longestSide));
        _fabVisible = true;
        Timer(animationDuration, () {
          setState(() => rect = null);
        });
      },
    );
  }

  void _onTapScan() async {
    if (_page == 2) {
      setState(() {
        inOutScan = 'in';
        _fabVisible = true;
        rect = RectGetter.getRectFromKey(rectGetterKey);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() =>
            rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide));
        Future.delayed(animationDuration + delay, _goToScanPage);
      });
    }
  }

  Future _goToScanPage() async {
    final resultBarcode =
        await Navigator.of(context).push(FadeRouteBuilder(page: ScanPage()));
    if (resultBarcode != "-1") {
      _resultBarcode = resultBarcode;
      inOutScan = 'out';
    }
    print(_resultBarcode);
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }
    return AnimatedPositioned(
      duration: animationDuration,
      left: rect.left,
      right: MediaQuery.of(context).size.width - rect.right,
      top: rect.top,
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.0),
          borderRadius: BorderRadius.all(Radius.elliptical(200, 200)),
          color: Colors.black,
        ),
      ),
    );
  }
}

class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeRouteBuilder({@required this.page})
      : super(
          pageBuilder: (context, animation1, animation2) => page,
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(opacity: animation1, child: child);
          },
        );
}

class OnlyOnePointerRecognizer extends OneSequenceGestureRecognizer {
  int _p = 0;
  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);
    if (_p == 0) {
      resolve(GestureDisposition.rejected);
      _p = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'only one pointer recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _p) {
      _p = 0;
    }
  }
}

class OnlyOnePointerRecognizerWidget extends StatelessWidget {
  final Widget child;
  OnlyOnePointerRecognizerWidget({this.child});
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        OnlyOnePointerRecognizer:
            GestureRecognizerFactoryWithHandlers<OnlyOnePointerRecognizer>(
          () => OnlyOnePointerRecognizer(),
          (OnlyOnePointerRecognizer instance) {},
        ),
      },
      child: child,
    );
  }
}
