import 'dart:async';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:community_material_icon/community_material_icon.dart';
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
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on Exception {
      barcodeScanRes = 'Failed to get platform version.';
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
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 2,
        height: 75.0,
        items: <Widget>[
          Icon(Icons.error, size: 40),
          Icon(Icons.monetization_on, size: 40),
          Icon(CommunityMaterialIcons.barcode_scan, size: 35),
          Icon(CommunityMaterialIcons.view_list, size: 40),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeOutCubic,
        animationDuration: Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            if (_page != index) {
              _page = index;
            }
          });
        },
      ),
      body: Container(
        color: Colors.blueAccent,
        child: Center(
          child: _switcherBody(),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () => scanBarcodeNormal(),
                child: Text("Start barcode scan"),
              ),
              RaisedButton(
                onPressed: () => startBarcodeScanStream(),
                child: Text("Start barcode scan stream"),
              ),
              Text(
                'Scan result : $_scanBarcode\n',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
      case 3:
        return new Container(child: Center(child: new Text("Lista de produtos")));
    }
    return null;
  }
}
