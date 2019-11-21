import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quanto_custa/navCustomPainter.dart';
import 'package:community_material_icon/community_material_icon.dart';

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
    "valor": "6,95",
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
    "valor": "8888,40",
    "imagem": "assets/omo.png",
  },
];

class _BarcodePageState extends State<BarcodePage> {
  double coordX = 0.0;
  Duration animationDuration = Duration(milliseconds: 200);
  Map<String, String> produto;
  DateTime now = DateTime.now();
  double valorTotalProduto;
  NumberFormat formatPreco = NumberFormat("#.00", "pt");
  bool addProdutoLista = false;
  bool okProdutoLista = false;
  bool botaoAddProdutoAtivado = true;
  int qtdProduto = 1;

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
          valorTotalProduto =
              double.parse(produto["valor"].replaceAll(',', '.'));
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
      height: widget.resultBarcode == ''
          ? MediaQuery.of(context).size.height - 150
          : 200.0,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(30.0, 19.0, 30.0, 41.0),
              height: MediaQuery.of(context).size.height,
              color: widget.resultBarcode == ''
                  ? Colors.blueAccent[100]
                  : Colors.white,
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
          padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueAccent[100],
              width: 4.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            color: Colors.blueAccent[100],
          ),
          child: Text(
            widget.resultBarcode,
            style: TextStyle(
              fontSize: 16.0,
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
                      padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 5.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start, //.center
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: true
                              ? <Widget>[
                                  buildNomeProduto(),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Stack(
                                    children: <Widget>[
                                      buildPrecoProduto(),
                                      buildBottaoAddProduto(),
                                    ],
                                  ),
                                ]
                              : <Widget>[
                                  MaterialButton(
                                    color: Colors.blueAccent,
                                    child: Text('ACESSAR PAGE 1'),
                                    onPressed: () {},
                                  ),
                                  MaterialButton(
                                    color: Colors.blueAccent,
                                    child: Text('ACESSAR PAGE 2'),
                                    onPressed: () {},
                                  ),
                                  MaterialButton(
                                    color: Colors.blueAccent,
                                    child: Text('ACESSAR PAGE 3'),
                                    onPressed: () {},
                                  ),
                                  MaterialButton(
                                    color: Colors.blueAccent,
                                    child: Text('ACESSAR PAGE 3'),
                                    onPressed: () {},
                                  ),
                                  MaterialButton(
                                    color: Colors.blueAccent,
                                    child: Text('ACESSAR PAGE 3'),
                                    onPressed: () {},
                                  ),
                                  MaterialButton(
                                    color: Colors.blueAccent,
                                    child: Text('ACESSAR PAGE 3'),
                                    onPressed: () {},
                                  ),
                                  MaterialButton(
                                    color: Colors.blueAccent,
                                    child: Text('ACESSAR PAGE 3'),
                                    onPressed: () {},
                                  ),
                                  MaterialButton(
                                    color: Colors.blueAccent,
                                    child: Text('ACESSAR PAGE 3'),
                                    onPressed: () {},
                                  ),
                                  MaterialButton(
                                    color: Colors.blueAccent,
                                    child: Text('ACESSAR PAGE 3'),
                                    onPressed: () {},
                                  ),
                                  MaterialButton(
                                    color: Colors.blueAccent,
                                    child: Text('ACESSAR PAGE 3'),
                                    onPressed: () {},
                                  ),
                                ]),
                    )
                  : Container(),
        ),
      ],
    );
  }

  Widget buildNomeProduto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20.0),
              color: Colors.blueAccent[100],
              child: CustomPaint(
                painter: NavCustomPainter(
                    0.12, 100, Colors.yellow[200], Directionality.of(context)),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5.0, 28.0, 5.0, 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          produto["nome"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          produto["quantidade"] + produto["unidadeMedida"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 17.0,
              child: Material(
                color: Colors.yellow[200],
                type: MaterialType.circle,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.error_outline, size: 30.0),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildPrecoProduto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20.0),
              color: Colors.blueAccent[100],
              child: CustomPaint(
                painter: NavCustomPainter(
                    0.12, 100, Colors.yellow[200], Directionality.of(context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: 73.0,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5.0, 28.0, 5.0, 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Preço - R\$',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    produto["valor"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: EdgeInsets.only(left: 3.5),
                        //color: Colors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: RawMaterialButton(
                                onPressed: () {
                                  if (qtdProduto > 1) {
                                    setState(() {
                                      qtdProduto--;
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.yellow[200],
                                  size: 30.0,
                                ),
                                shape: CircleBorder(),
                                elevation: 0,
                                fillColor: Colors.black,
                                padding: const EdgeInsets.all(5.0),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(qtdProduto.toString()),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RawMaterialButton(
                                onPressed: () {
                                  if (qtdProduto < 99) {
                                    setState(() {
                                      qtdProduto++;
                                    });
                                  }
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.yellow[200],
                                  size: 30.0,
                                ),
                                shape: CircleBorder(),
                                elevation: 0,
                                fillColor: Colors.black,
                                padding: const EdgeInsets.all(5.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 17.0,
              child: Material(
                color: Colors.yellow[200],
                type: MaterialType.circle,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.monetization_on, size: 30.0),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildBottaoAddProduto() {
    return Positioned(
      right: -35.0,
      bottom: 0,
      top: 20,
      child: FlatButton(
          color: Colors.redAccent,
          disabledColor: Colors.redAccent,
          disabledTextColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Container(
            height: 73.0,
            width: 131.0,
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 71.0,
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Total - R\$',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              formatPreco.format(valorTotalProduto),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedPositionedDirectional(
                  top: 0,
                  bottom: 0,
                  end: addProdutoLista ? -125.0 : 25.0,
                  curve: Curves.linear,
                  duration: Duration(milliseconds: 300),
                  child: Icon(
                    okProdutoLista
                        ? CommunityMaterialIcons.clipboard_check_outline
                        : CommunityMaterialIcons.clipboard_arrow_right_outline,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ),
          onPressed: botaoAddProdutoAtivado
              ? () {
                  setState(() {
                    botaoAddProdutoAtivado = false;
                    addProdutoLista = true;
                  });
                  Timer(Duration(milliseconds: 400), () {
                    setState(() {
                      okProdutoLista = true;
                      addProdutoLista = false;
                    });
                  });
                  Timer(Duration(milliseconds: 1200), () {
                    setState(() {
                      okProdutoLista = false;
                      botaoAddProdutoAtivado = true;
                    });
                  });
                }
              : null),
    );
  }
}
