import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quanto_custa/produtosAtivos.dart';
import 'package:quanto_custa/produtosHistorico.dart';
import 'package:intl/intl.dart';
import 'package:quanto_custa/navCustomPainter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  NumberFormat formatPreco = NumberFormat("#.00", "pt");
  double valorOrcamento = 0.0;

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
                0.12, 100, Colors.red[400], Directionality.of(context)),
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
          left: 17.0,
          child: Material(
            color: Colors.red[400],
            type: MaterialType.circle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(9.0, 8.5, 6.0, 6.5),
              child: Icon(FontAwesomeIcons.tag, size: 25.0),
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
              height: 250.0,
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
                  Text('data'),
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
                  icon: Icon(Icons.check_circle),
                ),
                Tab(
                  text: "HISTÓRICO DE LEITURAS",
                  icon: Icon(Icons.crop_square),
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
