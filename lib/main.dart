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
  String _scanBarcode = "";

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
      if (barcodeScanRes != "-1") {
        _scanBarcode = barcodeScanRes;
      }
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
                ? const EdgeInsets.all(2.5)
                : const EdgeInsets.only(top: 10.0),
            child: Icon(Icons.error_outline, size: 35),
          ),
          Padding(
            padding: _page == 1
                ? const EdgeInsets.all(0.0)
                : const EdgeInsets.only(top: 10.0),
            child: Icon(Icons.person_outline, size: 40),
          ),
          Padding(
            padding: _page == 2
                ? const EdgeInsets.fromLTRB(4.0, 1.0, 4.0, 4.0)
                : const EdgeInsets.only(top: 10.0),
            child: Icon(CommunityMaterialIcons.barcode_scan, size: 35),
          ),
          Padding(
            padding: _page == 3
                ? const EdgeInsets.fromLTRB(4.0, 0.9, 4.0, 4.1)
                : const EdgeInsets.only(top: 10.0),
            child:
                Icon(CommunityMaterialIcons.clipboard_text_outline, size: 35),
          ),
        ],
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.blueAccent,
        backgroundColor: Color(0xffd6f6ff),
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
        padding: _page == 0
            ? const EdgeInsets.all(10.0)
            : _page == 1
                ? const EdgeInsets.all(10.0)
                : _page == 2
                    ? EdgeInsets.only(bottom: 80.0)
                    : const EdgeInsets.all(10.0),
        color: Color(0xffd6f6ff),
        child: SafeArea(
          child: Center(
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Center(
                      child: _switcherBody(),
                    ),
                    Center(
                      child: Container(
                        width: '$_scanBarcode' == '' ? 0 : null,
                        margin: EdgeInsets.only(top: 178.0),
                        child: _page == 2
                            ? Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffd6f6ff),
                                    width: 5.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                  color: Color(0xffd6f6ff),
                                ),
                                child: Text(
                                  '$_scanBarcode',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
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
            elevation: 0,
            onPressed: () {
              scanBarcodeNormal();
            },
            label: Text('ESCANEAR CÓDIGO DE BARRAS'),
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.black,
            splashColor: Colors.orange,
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
        return new Container(child: Center(child: new Text("Perfil")));
      case 2:
        return new Container(
          alignment: Alignment.center,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
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
                            visible: '$_scanBarcode' == '',
                            child: Container(
                              child: Text('LOGO DO APP'),
                            ),
                          ),
                          Visibility(
                            visible: '$_scanBarcode' != '',
                            child: Container(
                              child: Image.network(
                                'https://www.google.com.br/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
                                loadingBuilder: (
                                  BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
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
                    Text('data'),
                  ],
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
