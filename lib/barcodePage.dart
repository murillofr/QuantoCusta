import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:quanto_custa/navCustomPainter.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:quanto_custa/produtosAtivos.dart';
import 'package:quanto_custa/produtosHistorico.dart';

class Post {
  final String barCode;
  final String description;
  final int id;
  final String imgUrl;
  final String name;
  final double price;

  Post({
    this.barCode,
    this.description,
    this.id,
    this.imgUrl,
    this.name,
    this.price,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        barCode: json["barCode"],
        description: json["description"],
        id: json["id"],
        imgUrl: json["imgUrl"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "barCode": barCode,
        "description": description,
        "id": id,
        "imgUrl": imgUrl,
        "name": name,
        "price": price,
      };
}

class BarcodePage extends StatefulWidget {
  final String resultBarcode;
  final String inOutScan;
  final int page;
  final GlobalKey bottomNavigationKey;
  final Future<Post> post;

  const BarcodePage(
      {Key key,
      this.resultBarcode,
      this.inOutScan,
      this.page,
      this.bottomNavigationKey,
      this.post})
      : super(key: key);

  @override
  _BarcodePageState createState() => _BarcodePageState();
}

List<Map<String, String>> jsonProdutos = [
  {
    "barcode": "7891000023808",
    "nome": "Negresco",
    "descricao": "Biscoito Recheado Negresco 140g",
    "valor": "1,50",
    "imagem": "assets/negresco.png",
  },
  {
    "barcode": "7622210782281",
    "nome": "Club Social Crostini",
    "descricao": "Club Social Crostini - Sabor original 20g",
    "valor": "1,00",
    "imagem": "assets/clubsocial.png",
  },
  {
    "barcode": "7899846061442",
    "nome": "Desodorante Todo Dia",
    "descricao": "Desodorante Natura Todo Dia 80g",
    "valor": "17,00",
    "imagem": "assets/desodorante.png",
  },
];

class _BarcodePageState extends State<BarcodePage> {
  double coordX = 0.0;
  Duration animationDuration = Duration(milliseconds: 200);
  Map<String, String> produto;
  DateTime now = DateTime.now();
  DateTime nowExpired;
  String dataLeitura = '';
  String horaLeitura = '';
  Duration tempoExpiracaoScan = Duration(seconds: 30);
  double valorTotalProduto;
  NumberFormat formatPreco = NumberFormat("#.00", "pt");
  bool addProdutoLista = false;
  bool okProdutoLista = false;
  bool botaoAddProdutoAtivado = true;
  bool refazLeitura;
  int qtdProduto = 1;
  http.Response response;
  String restOk = '';

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
            nowExpired = now.add(tempoExpiracaoScan);
          }
        }
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  Future<Post> fetchPost(barcode) async {
    var resultBarcode = barcode;
    response = await http.get(
        'https://howmuch-app.herokuapp.com/products/barcode/$resultBarcode');
    if (response.statusCode == 200) {
      setState(() => {
            restOk = 'ok',
            valorTotalProduto = Post.fromJson(json.decode(response.body)).price
          });
      // If the call to the server was successful, parse the JSON
      return Post.fromJson(json.decode(response.body));
    } else {
      setState(() => {restOk = 'erro'});
      // If that call was not successful, throw an error.
      print('Falha ao localizar produto');
      throw Exception('Falha ao localizar produto');
    }
  }

  void _getProduto() {
    setState(() => {restOk = 'loading'});
    fetchPost(widget.resultBarcode);

    for (var i = 0; i < jsonProdutos.length; i++) {
      if (jsonProdutos[i]['barcode'] == widget.resultBarcode) {
        setState(() {
          produto = jsonProdutos[i];
          qtdProduto = 1;
          valorTotalProduto =
              double.parse(produto["valor"].replaceAll(',', '.'));
          now = DateTime.now();
          dataLeitura = DateFormat("dd/MM/yyyy").format(now);
          horaLeitura = DateFormat("HH:mm:ss").format(now);
          ProdutosHistorico.addProduto(produto, dataLeitura, horaLeitura);
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

  _refazerLeitura() {
    setState(() {
      botaoAddProdutoAtivado = false;
      refazLeitura = (DateTime.now().isAfter(nowExpired));
    });

    if (refazLeitura) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () {
                setState(() {
                  botaoAddProdutoAtivado = true;
                });
                return Future.value(true);
              },
              child: FlareGiffyDialog(
                flarePath: 'assets/space_demo.flr',
                flareAnimation: 'loading',
                entryAnimation: EntryAnimation.BOTTOM_LEFT,
                title: Text(
                  'O TEMPO PASSA...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
                description: Text(
                    'A leitura feita do código de barras é quase tão antiga quanto o universo.\nPor favor, refaça-a.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                buttonRadius: 30.0,
                buttonOkColor: Colors.black,
                onlyOkButton: true,
                onOkButtonPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    botaoAddProdutoAtivado = true;
                  });
                },
              ),
            );
          });
    } else {
      setState(() {
        addProdutoLista = true;
      });
      Timer(Duration(milliseconds: 400), () {
        setState(() {
          okProdutoLista = true;
          addProdutoLista = false;
          ProdutosAtivos.addProduto(produto, qtdProduto, valorTotalProduto);
        });
      });
      Timer(Duration(milliseconds: 1200), () {
        setState(() {
          okProdutoLista = false;
          botaoAddProdutoAtivado = true;
        });
      });
    }
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
                          buildDataHoraPesquisa(dataLeitura, horaLeitura),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            child: restOk == 'ok'
                                ? buildInfosProduto()
                                : Container(),
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
          : 181.0,
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
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                // set the default style for the children TextSpans
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(fontSize: 75),
                                children: [
                                  TextSpan(
                                      text: 'Q',
                                      style: TextStyle(color: Colors.white)),
                                  TextSpan(
                                      text: 'UANTO\n',
                                      style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                      text: 'C',
                                      style: TextStyle(color: Colors.white)),
                                  TextSpan(
                                    text: 'USTA',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: '                                             ',
                                    style: TextStyle(fontSize: 2.0),
                                  ),
                                  TextSpan(
                                    text: '?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : restOk == 'ok'
                            ? Image.network(
                                Post.fromJson(json.decode(response.body))
                                    .imgUrl,
                              )
                            : Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: restOk == 'erro'
                                      ? <Widget>[
                                          Icon(Icons.error_outline,
                                              size: 100.0),
                                          Text(
                                            'PRODUTO NÃO LOCALIZADO',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]
                                      : <Widget>[
                                          CircularProgressIndicator(),
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
        margin: EdgeInsets.only(top: 159.0),
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
        margin: EdgeInsets.only(top: 160.0),
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
              : Container(
                  padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, //.center
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      buildNomeProduto(),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: buildPrecoProduto(),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            flex: 4,
                            child: buildQtdBotaoAdd(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                    0.12, 100, Colors.yellow[400], Directionality.of(context)),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 66.0),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(66.0, 0.0, 5.0, 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            restOk == 'ok'
                                ? Post.fromJson(json.decode(response.body)).name
                                : '',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            restOk == 'ok'
                                ? Post.fromJson(json.decode(response.body))
                                    .description
                                : '',
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
            ),
            Positioned(
              top: 0,
              left: 17.0,
              child: Material(
                color: Colors.yellow[400],
                type: MaterialType.circle,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.5, 6.3, 6.5, 8.7),
                  child: Icon(FontAwesomeIcons.info, size: 25.0),
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
              padding: EdgeInsets.all(0.0),
              color: Colors.blueAccent[100],
              child: CustomPaint(
                painter: NavCustomPainter(0.12, 100, Colors.greenAccent[400],
                    Directionality.of(context)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 62,
                      top: 5,
                      right: 0,
                      child: Container(
                        child: Text(
                          'PREÇO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: Container(
                          height: 80.0,
                          padding: EdgeInsets.fromLTRB(5.0, 28.0, 5.0, 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'R\$',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                flex: 5,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    restOk == 'ok'
                                        ? formatPreco.format(Post.fromJson(
                                                json.decode(response.body))
                                            .price)
                                        : '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 33.0),
                                  ),
                                ),
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
            Positioned(
              top: 0,
              left: 17.0,
              child: Material(
                color: Colors.greenAccent[400],
                type: MaterialType.circle,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(9.0, 8.5, 6.0, 6.5),
                  child: Icon(FontAwesomeIcons.tag, size: 25.0),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Container(
          height: 70.0,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 3.0)),
            color: Colors.white,
            disabledColor: Colors.white,
            disabledTextColor: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(
                    FontAwesomeIcons.solidEye,
                    size: 30.0,
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 2,
                  child: Text(
                    'REPORTAR ERRO',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13.4),
                  ),
                ),
              ],
            ),
            onPressed: botaoAddProdutoAtivado
                ? () {
                    setState(() {
                      botaoAddProdutoAtivado = false;
                    });
                    Timer(Duration(milliseconds: 150), () {
                      final CurvedNavigationBarState navBarState =
                          widget.bottomNavigationKey.currentState;
                      setState(() {
                        botaoAddProdutoAtivado = true;
                      });
                      navBarState.setPage(0);
                    });
                    Timer(Duration(milliseconds: 400), () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                // set the default style for the children TextSpans
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(fontSize: 25),
                                children: [
                                  TextSpan(
                                    text: 'Reporte do produto\n',
                                  ),
                                  TextSpan(
                                      text: Post.fromJson(
                                              json.decode(response.body))
                                          .name,
                                      style: TextStyle(color: Colors.blue)),
                                  TextSpan(
                                    text: '\nenviado com sucesso. Obrigado!',
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  }
                : null,
          ),
        ),
      ],
    );
  }

  Widget buildQtdBotaoAdd() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.all(0.0),
              color: Colors.blueAccent[100],
              child: CustomPaint(
                painter: NavCustomPainter(
                    0.521, 100, Colors.yellow[400], Directionality.of(context)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      top: 5,
                      right: 62,
                      child: Container(
                        child: Text(
                          'QUANTIDADE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: Container(
                          height: 60.0,
                          padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: RawMaterialButton(
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.yellow[400],
                                      size: 30.0,
                                    ),
                                    shape: CircleBorder(),
                                    elevation: 0,
                                    fillColor: Colors.black,
                                    onPressed: botaoAddProdutoAtivado
                                        ? (qtdProduto > 1)
                                            ? () {
                                                setState(() {
                                                  qtdProduto--;
                                                  valorTotalProduto =
                                                      Post.fromJson(json.decode(
                                                                  response
                                                                      .body))
                                                              .price *
                                                          qtdProduto;
                                                });
                                              }
                                            : null
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Text(
                                          qtdProduto.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: RawMaterialButton(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.yellow[400],
                                      size: 30.0,
                                    ),
                                    shape: CircleBorder(),
                                    elevation: 0,
                                    fillColor: Colors.black,
                                    onPressed: botaoAddProdutoAtivado
                                        ? (qtdProduto < 99)
                                            ? () {
                                                setState(() {
                                                  qtdProduto++;
                                                  valorTotalProduto =
                                                      Post.fromJson(json.decode(
                                                                  response
                                                                      .body))
                                                              .price *
                                                          qtdProduto;
                                                });
                                              }
                                            : null
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 17.0,
              child: Material(
                color: Colors.yellow[400],
                type: MaterialType.circle,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(CommunityMaterialIcons.numeric, size: 32.0),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Stack(
          children: <Widget>[
            Container(
              height: 70.0,
              margin: EdgeInsets.only(top: 20.0),
              padding: EdgeInsets.all(0.0),
              color: Colors.blueAccent[100],
              child: CustomPaint(
                painter: NavCustomPainter(
                    0.12, 100, Colors.red[400], Directionality.of(context)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: FlatButton(
                        padding: EdgeInsets.all(0.0),
                        color: Colors.transparent,
                        disabledColor: Colors.transparent,
                        disabledTextColor: Colors.black,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Center(
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                                  child: buildBottaoAddProduto(),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 62,
                              top: 5,
                              right: 0,
                              child: Container(
                                child: Text(
                                  'TOTAL',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed:
                            botaoAddProdutoAtivado ? _refazerLeitura : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -4,
              left: 12.0,
              child: Material(
                color: Colors.blueAccent[100],
                type: MaterialType.circle,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(7.5, 6.5, 7.5, 8.5),
                  child: Icon(FontAwesomeIcons.equals,
                      size: 35.0, color: Colors.blueAccent[100]),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 17.0,
              child: Material(
                color: Colors.red[400],
                type: MaterialType.circle,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(7.5, 6.5, 7.5, 8.5),
                  child: Icon(FontAwesomeIcons.equals, size: 25.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBottaoAddProduto() {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          right: 40,
          left: 0,
          top: 0,
          child: Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      'R\$',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    flex: 5,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        formatPreco.format(valorTotalProduto),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 33.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedPositionedDirectional(
          top: 0,
          bottom: 0,
          end: addProdutoLista ? -61.0 : 2.6,
          curve: Curves.linear,
          duration: Duration(milliseconds: 300),
          child: Icon(
            okProdutoLista
                ? CommunityMaterialIcons.clipboard_check_outline
                : CommunityMaterialIcons.clipboard_arrow_right_outline,
            size: 35.0,
          ),
        ),
      ],
    );
  }
}
