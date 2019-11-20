import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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

List<Map<String, String>> jsonProdutos = [
  {
    "barcode": "7891321063293",
    "nome": "Café Cajubá",
    "unidadeMedida": "g",
    "quantidade": "500",
    "valor": "6,90",
    "imagem": "assets/cajuba.png",
  },
  {
    "barcode": "7891360623090",
    "nome": "Margarina Qualy",
    "unidadeMedida": "g",
    "quantidade": "500",
    "valor": "5,50",
    "imagem": "assets/qualy.png",
  },
  {
    "barcode": "7897629207452",
    "nome": "Sabão em pó Omo Multiação",
    "unidadeMedida": "kg",
    "quantidade": "1",
    "valor": "10,45",
    "imagem": "assets/omo.png",
  },
];

class _BarcodePageState extends State<BarcodePage> {
  double coordX = 0.0;
  Duration animationDuration = Duration(milliseconds: 200);
  Map<String, String> produto;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

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
            _getProduto();
            now = DateTime.now();
          }
        }
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  void _getProduto() {
    for (var i = 0; i < jsonProdutos.length; i++) {
      if (jsonProdutos[i]['barcode'] == widget.resultBarcode) {
        setState(() {
          produto = jsonProdutos[i];
        });
        break;
      } else {
        setState(() {
          produto = {};
        });
      }
    }
    print(produto);
  }

  @override
  Widget build(BuildContext context) {
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
                          buildImagemProduto(),
                          buildBarcodeProduto(),
                          buildDataHoraPesquisa(
                              DateFormat("dd/MM/yyyy").format(now),
                              DateFormat("HH:mm:ss").format(now)),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: buildInfosProduto(),
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

  Widget buildImagemProduto() {
    return Container(
      color: const Color(0xff808000),
      height: 200.0,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(30.0, 19.0, 30.0, 41.0),
              height: 200,
              color: Colors.white,
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: widget.resultBarcode == ''
                        ? Container(
                            padding: EdgeInsets.only(top: 22.0),
                            child: Text('LOGO DO APP'),
                          )
                        : produto.length > 0
                            ? Image(
                                image: AssetImage(
                                  produto["imagem"],
                                ),
                              )
                            : Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.error_outline, size: 100.0),
                                    Text(
                                      'PRODUTO NÃO LOCALIZADO',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBarcodeProduto() {
    return Center(
      child: Container(
        width: widget.resultBarcode == '' ? 0 : null,
        margin: EdgeInsets.only(top: 178.0),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
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
    );
  }

  Widget buildDataHoraPesquisa(String data, String hora) {
    return Visibility(
      visible: widget.resultBarcode != '',
      child: Container(
        margin: EdgeInsets.only(top: 178.0),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Stack(
            children: <Widget>[
              Text(
                data,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  hora,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfosProduto() {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: widget.resultBarcode == ''
              ? Container()
              : produto.length > 0
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start, //.center
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            produto["nome"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                            ),
                          ),
                          Text(
                            produto["quantidade"] + produto["unidadeMedida"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
        ),
      ],
    );
  }
}
