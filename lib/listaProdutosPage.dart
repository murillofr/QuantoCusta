import 'dart:async';

import 'package:flutter/material.dart';

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

class _ListaProdutosPageState extends State<ListaProdutosPage>{
  double coordX = 0.0;
  Duration animationDuration = Duration(milliseconds: 200);

  @override
  void initState() {
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
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: MyCustomAppBar(
            height: 250,
          ),
          body: TabBarView(
            children: [
              TextField(),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const MyCustomAppBar({
    Key key,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 150.0,
          child: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.directions_car),
                  text: "Non persistent",
                ),
                Tab(icon: Icon(Icons.directions_transit), text: "Persistent"),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(),
            ),
            SizedBox(width: 10.0),
            Expanded(
              flex: 4,
              child: Container(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
