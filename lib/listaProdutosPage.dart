import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quanto_custa/produtosAtivos.dart';
import 'package:quanto_custa/produtosHistorico.dart';
import 'package:intl/intl.dart';
import 'package:quanto_custa/navCustomPainter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:community_material_icon/community_material_icon.dart';

double valorTodosProdutos = 0.0;

class ListaProdutosPage extends StatefulWidget {
  final int page;
  final int pageAntiga;
  final String controleTransicao;
  final GlobalKey bottomNavigationKey;

  const ListaProdutosPage(
      {Key key,
      this.page,
      this.pageAntiga,
      this.controleTransicao,
      this.bottomNavigationKey})
      : super(key: key);

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();

  static atualizarValorFilhoParaPai(double valor) {
    valorTodosProdutos = valor;
  }
}

class _ListaProdutosPageState extends State<ListaProdutosPage>
    with SingleTickerProviderStateMixin {
  double coordX = 0.0;
  Duration animationDuration = Duration(milliseconds: 200);
  TabController _tabController;
  TextEditingController _textFieldController = TextEditingController();
  NumberFormat formatPreco = NumberFormat("#.00", "pt");
  NumberFormat formatPrecoZero = NumberFormat("0.00", "pt");
  double valorOrcamento = 100.0;
  double widthBarra = 0.0;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  void didUpdateWidget(ListaProdutosPage oldWidget) {
    setState(() {
      if (widget.page == 3) {
        if (widget.page != oldWidget.page) {
          if (coordX == 0.0) {
            animationDuration = Duration(milliseconds: 0);
            coordX = widget.pageAntiga != 0
                ? MediaQuery.of(context).size.width
                : widget.controleTransicao == 'TAP'
                    ? MediaQuery.of(context).size.width
                    : -MediaQuery.of(context).size.width;

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
        }
      }
    });
    super.didUpdateWidget(oldWidget);
  }

  atualizarValorDentroPai(double valor) {
    setState(() {
      valorTodosProdutos = valor;
    });
  }

  Widget buildOrcamento() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0),
          padding: EdgeInsets.all(0.0),
          color: Colors.white,
          child: CustomPaint(
            painter: NavCustomPainter(
                0.12, 100, Colors.greenAccent[400], Directionality.of(context)),
            child: FlatButton(
              padding: EdgeInsets.all(0.0),
              color: Colors.transparent,
              disabledColor: Colors.transparent,
              disabledTextColor: Colors.black,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 62,
                    top: 5,
                    right: 0,
                    child: Container(
                      child: Text(
                        'ORÇAMENTO',
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
                        height: 75.0,
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
                                  valorOrcamento >= 1
                                      ? formatPreco.format(valorOrcamento)
                                      : formatPrecoZero.format(valorOrcamento),
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
              onPressed: () {
                _textFieldController.clear();
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Atualizar orçamento',
                        textAlign: TextAlign.center,
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            TextField(
                              controller: _textFieldController,
                              inputFormatters: [
                                WhitelistingTextInputFormatter(RegExp(
                                    r'^(?:-?(?:[0-9]+))?(?:\,[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$'))
                              ],
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('Atualizar'),
                          onPressed: () {
                            if (_textFieldController.text == "") {
                              Navigator.of(context).pop();
                            } else {
                              var temp = double.parse(_textFieldController.text
                                  .replaceAll(',', '.'));
                              setState(() {
                                valorOrcamento =
                                    double.parse(temp.toStringAsFixed(2));
                              });
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
        Positioned(
          top: -4,
          left: 12.0,
          child: Material(
            color: Colors.white,
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
            color: Colors.greenAccent[400],
            type: MaterialType.circle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(9.5, 8.0, 8.5, 10.0),
              child: Icon(FontAwesomeIcons.calculator, size: 22.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildValorTotalProdutos() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20.0),
          padding: EdgeInsets.all(0.0),
          color: Colors.white,
          child: CustomPaint(
            painter: NavCustomPainter(
                0.448, 100, Colors.red[400], Directionality.of(context)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  top: 5,
                  right: 62,
                  child: Container(
                    child: Text(
                      'TOTAL',
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
                      height: 75.0,
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
                                valorTodosProdutos > 0.0
                                    ? formatPreco.format(valorTodosProdutos)
                                    : "0,00",
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
          right: 17.0,
          child: Material(
            color: Colors.red[400],
            type: MaterialType.circle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7.5, 10.0, 12.5, 10.0),
              child: Icon(FontAwesomeIcons.moneyCheckAlt, size: 20.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration,
      transform: Matrix4.translationValues(coordX, 0.0, 0.0),
      child: Column(
        children: [
          Material(
            child: Container(
              padding: EdgeInsets.all(5.0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: buildOrcamento(),
                          ),
                          SizedBox(width: 5.0),
                          Expanded(
                            flex: 1,
                            child: buildValorTotalProdutos(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        color: valorOrcamento >= valorTodosProdutos
                            ? Colors.greenAccent[400]
                            : Colors.red[400],
                        height: 30.0,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Positioned(
                        top: 10,
                        child: Container(
                          color: valorOrcamento >= valorTodosProdutos
                              ? Colors.red[400]
                              : Colors.greenAccent[400],
                          height: 30.0,
                          width: valorOrcamento >= valorTodosProdutos
                              ? (MediaQuery.of(context).size.width *
                                      (valorTodosProdutos *
                                          100 /
                                          valorOrcamento)) /
                                  100
                              : (MediaQuery.of(context).size.width *
                                      (valorOrcamento *
                                          100 /
                                          valorTodosProdutos)) /
                                  100,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: AnimatedContainer(
                          duration: animationDuration,
                          height: 30.0,
                          width: valorOrcamento >= valorTodosProdutos
                              ? (MediaQuery.of(context).size.width *
                                              (valorTodosProdutos *
                                                  100 /
                                                  valorOrcamento)) /
                                          100 >
                                      57.0
                                  ? (MediaQuery.of(context).size.width *
                                          (valorTodosProdutos *
                                              100 /
                                              valorOrcamento)) /
                                      100
                                  : 57.0
                              : (MediaQuery.of(context).size.width *
                                              (valorOrcamento *
                                                  100 /
                                                  valorTodosProdutos)) /
                                          100 >
                                      57.0
                                  ? (MediaQuery.of(context).size.width *
                                          (valorOrcamento *
                                              100 /
                                              valorTodosProdutos)) /
                                      100
                                  : 57.0,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 9.0),
                              child: valorOrcamento >= valorTodosProdutos
                                  ? Text(
                                      (valorTodosProdutos * 100 / valorOrcamento) >=
                                              1
                                          ? formatPrecoZero
                                                  .format((valorTodosProdutos *
                                                      100 /
                                                      valorOrcamento))
                                                  .toString() +
                                              "%"
                                          : (valorTodosProdutos *
                                                      100 /
                                                      valorOrcamento) <
                                                  0.01
                                              ? ''
                                              : formatPrecoZero
                                                      .format(
                                                          (valorTodosProdutos *
                                                              100 /
                                                              valorOrcamento))
                                                      .toString() +
                                                  "%",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
                                    )
                                  : Text(
                                      (valorTodosProdutos * 100 / valorOrcamento) >=
                                              1
                                          ? formatPrecoZero
                                                  .format((valorOrcamento *
                                                      100 /
                                                      valorTodosProdutos))
                                                  .toString() +
                                              "%"
                                          : (valorOrcamento *
                                                      100 /
                                                      valorTodosProdutos) <
                                                  0.01
                                              ? ''
                                              : formatPrecoZero
                                                      .format(
                                                          (valorOrcamento *
                                                              100 /
                                                              valorTodosProdutos))
                                                      .toString() +
                                                  "%",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
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
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black54,
                  width: 3.0,
                ),
              ),
            ),
            child: TabBar(
              indicatorColor: Colors.black,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.black, width: 3.0),
                insets: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, -3.0),
              ),
              labelStyle: TextStyle(fontSize: 13.0),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              isScrollable: false,
              unselectedLabelStyle: TextStyle(fontSize: 13.0),
              controller: _tabController,
              tabs: [
                Tab(
                  text: "LISTA DE PRODUTOS",
                  icon: Icon(CommunityMaterialIcons.clipboard_text_outline,
                      size: 30),
                ),
                Tab(
                  text: "HISTÓRICO DE LEITURAS",
                  icon: Icon(CommunityMaterialIcons.history, size: 30),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ProdutosAtivos(
                    parentAction: atualizarValorDentroPai,
                  ),
                  ProdutosHistorico(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
