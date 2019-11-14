/*import 'dart:async';

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

final routeObserver = RouteObserver<PageRoute>();
final duration = const Duration(milliseconds: 500);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  int _page = 2;
  GlobalKey _fabKey = GlobalKey();
  bool _fabVisible = true;
  String _resultBarcode = "";
  GlobalKey _bottomNavigationKey = GlobalKey();
  String inOutScan = '';

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return new Scaffold(
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
            child:
                Icon(CommunityMaterialIcons.clipboard_text_outline, size: 30),
          ),
        ],
        onTap: (index) {
          setState(() {
            if (_page != index) {
              _page = index;
            }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: _fabVisible && _page == 2,
        child: _buildFAB(context, key: _fabKey),
      ),
    );
  }

  Widget _switcherBody() {
    return new Stack(
      children: <Widget>[
        new Offstage(
          offstage: _page != 0,
          child: new TickerMode(
            enabled: _page == 0,
            child: new MaterialApp(
              debugShowCheckedModeBanner: false,
              home: new AlertPage(),
            ),
          ),
        ),
        new Offstage(
          offstage: _page != 1,
          child: new TickerMode(
            enabled: _page == 1,
            child: new MaterialApp(
              debugShowCheckedModeBanner: false,
              home: new PerfilPage(),
            ),
          ),
        ),
        new Offstage(
          offstage: _page != 2,
          child: new TickerMode(
            enabled: _page == 2,
            child: new MaterialApp(
              debugShowCheckedModeBanner: false,
              home: new BarcodePage(
                resultBarcode: '$_resultBarcode',
                inOutScan: '$inOutScan',
              ),
            ),
          ),
        ),
        new Offstage(
          offstage: _page != 3,
          child: new TickerMode(
            enabled: _page == 3,
            child: new MaterialApp(
              debugShowCheckedModeBanner: false,
              home: new ListaProdutosPage(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  didPopNext() {
    // Show back the FAB on transition back ended
    Timer(duration, () {
      setState(() => _fabVisible = true);
    });
  }

  Widget _buildFAB(context, {key}) => Container(
        child: FloatingActionButton.extended(
          label: Text('ESCANEAR CÓDIGO DE BARRAS'),
          elevation: 0,
          backgroundColor: Colors.black,
          key: key,
          onPressed: () => {
            _onFabTap(context),
            inOutScan = 'in',
          },
        ),
      );

  _onFabTap(BuildContext context) async {
    // Hide the FAB on transition start
    setState(() => _fabVisible = false);

    final RenderBox fabRenderBox = _fabKey.currentContext.findRenderObject();
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);

    final resultBarcode = await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: duration,
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            ScanPage(),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) =>
            _buildTransition(child, animation, fabSize, fabOffset),
      ),
    );
    if (resultBarcode != "-1") {
      _resultBarcode = resultBarcode;
      inOutScan = 'out';
    }
    print('VAI PRINTAR');
    print(_resultBarcode);
  }

  Widget _buildTransition(
    Widget page,
    Animation<double> animation,
    Size fabSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    final offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final radius = borderTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab = Opacity(
      opacity: 1 - easeAnimation.value,
      child: _buildFAB(context),
    );

    Widget positionedClippedChild(Widget child) => Positioned(
        width: size.width,
        height: size.height,
        left: offset.dx,
        top: offset.dy,
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ));

    return Stack(
      children: [
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
  }
}
*/