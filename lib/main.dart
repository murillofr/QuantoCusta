import 'dart:async';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(
      MaterialApp(
        home: BottomNavBar(),
        debugShowCheckedModeBanner: false,
      ),
    );

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 2;
  GlobalKey _bottomNavigationKey = GlobalKey();
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancelar", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on Exception {
      barcodeScanRes = 'Falha ao tentar acessar a câmera.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 2,
        height: 60.0,
        items: <Widget>[
          Padding(
            padding: _page == 0
                ? const EdgeInsets.all(0.0)
                : const EdgeInsets.only(top: 10.0),
            child: Icon(Icons.error, size: 40),
          ),
          Padding(
            padding: _page == 1
                ? const EdgeInsets.all(0.0)
                : const EdgeInsets.only(top: 10.0),
            child: Icon(Icons.monetization_on, size: 40),
          ),
          Padding(
            padding: _page == 2
                ? const EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 4.0)
                : const EdgeInsets.only(top: 10.0),
            child: Icon(CommunityMaterialIcons.barcode_scan, size: 35),
          ),
          Padding(
            padding: _page == 3
                ? const EdgeInsets.all(0.0)
                : const EdgeInsets.only(top: 10.0),
            child: Icon(CommunityMaterialIcons.view_list, size: 40),
          ),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.decelerate,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            if (_page != index) {
              _page = index;
            }
          });
        },
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
        color: Colors.blueAccent,
        child: SafeArea(
          child: Center(
            child: ListView(
              children: <Widget>[
                _switcherBody(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: _page == 2,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.fromLTRB(32.0, 0.0, 0.0, 14.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              scanBarcodeNormal();
            },
            label: Text('ESCANEAR CÓDIGO DE BARRAS'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            splashColor: Colors.blue.withAlpha(30),
          ),
        ),
      ),
    );
  }

  Widget _switcherBody() {
    switch (_page) {
      case 0:
        return new Container(child: Center(child: new Text("Envio de erros")));
      case 1:
        return new Container(child: Center(child: new Text("Cupons")));
      case 2:
        return new Container(
          alignment: Alignment.center,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Card(
                  color: Color.fromRGBO(255, 200, 128, 1.0),
                  margin: EdgeInsets.only(bottom: 7.0),
                  child: Container(
                    constraints: BoxConstraints(
                        minWidth: 100,
                        maxWidth: 600,
                        minHeight: 100,
                        maxHeight: 200),
                    width: 3000,
                    height: 3000,
                    child: Center(
                      child: Text('Imagem do produto'),
                    ),
                  ),
                ),
              ),
              Container(
                child: Text(
                  '$_scanBarcode',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        );
      case 3:
        return new Container(
            child: Center(child: new Text("Lista de produtos")));
    }
    return null;
  }
}
