import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quanto_custa/produtosAtivos.dart';
import 'package:quanto_custa/produtosHistorico.dart';

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
}

class _ListaProdutosPageState extends State<ListaProdutosPage>
    with SingleTickerProviderStateMixin {
  double coordX = 0.0;
  Duration animationDuration = Duration(milliseconds: 200);
  TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration,
      transform: Matrix4.translationValues(coordX, 0.0, 0.0),
      child: Column(
        children: [
          Container(
            height: 150.0,
            color: Colors.green,
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
                  ProdutosAtivos(),
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
