import 'package:flutter/material.dart';

class ProdutosHistorico extends StatefulWidget {

  const ProdutosHistorico({
    Key key,
  }) : super(key: key);

  @override
  ProdutosHistoricoState createState() => ProdutosHistoricoState();
}

class ProdutosHistoricoState extends State<ProdutosHistorico>
    with AutomaticKeepAliveClientMixin<ProdutosHistorico> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextField(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
