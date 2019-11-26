import 'package:flutter/material.dart';

final GlobalKey<AnimatedListState> _listKey = GlobalKey();

class ProdutosAtivos extends StatefulWidget {
  const ProdutosAtivos({
    Key key,
  }) : super(key: key);

  @override
  ProdutosAtivosState createState() => ProdutosAtivosState();

  static addProduto(Map<String, String> produto, int qtdProduto) {
    int index = listData.length;
    listData.add(
      ProdutoAtivoModel(
        barcode: produto["barcode"],
        nome: produto["nome"],
        unidadeMedida: produto["unidadeMedida"],
        quantidade: produto["quantidade"],
        valor: produto["valor"],
        imagem: produto["imagem"],
        qtdProduto: qtdProduto.toString(),
      ),
    );
    if (_listKey.currentState != null) {
      _listKey.currentState
          .insertItem(index, duration: Duration(milliseconds: 500));
    }
  }
}

class ProdutosAtivosState extends State<ProdutosAtivos>
    with AutomaticKeepAliveClientMixin<ProdutosAtivos> {
  @override
  bool get wantKeepAlive => true;

  void delProduto(int index) {
    var produto = listData.removeAt(index);
    _listKey.currentState.removeItem(
      index,
      (BuildContext context, Animation<double> animation) {
        return FadeTransition(
          opacity:
              CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
          child: SizeTransition(
            sizeFactor:
                CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
            axisAlignment: 0.0,
            child: _buildItem(produto),
          ),
        );
      },
      duration: Duration(milliseconds: 600),
    );
  }

  Widget _buildItem(ProdutoAtivoModel produto, [int index]) {
    return ListTile(
      key: ValueKey<ProdutoAtivoModel>(produto),
      title: Text(produto.nome),
      subtitle: Text(produto.barcode),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(produto.imagem),
      ),
      onLongPress: index != null ? () => delProduto(index) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedList(
      key: _listKey,
      initialItemCount: listData.length,
      itemBuilder: (BuildContext context, int index, Animation animation) {
        return FadeTransition(
          opacity: animation,
          child: _buildItem(listData[index], index),
        );
      },
    );
  }
}

class ProdutoAtivoModel {
  ProdutoAtivoModel({
    this.barcode,
    this.nome,
    this.unidadeMedida,
    this.quantidade,
    this.valor,
    this.imagem,
    this.qtdProduto,
  });
  String barcode;
  String nome;
  String unidadeMedida;
  String quantidade;
  String valor;
  String imagem;
  String qtdProduto;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProdutoAtivoModel &&
          runtimeType == other.runtimeType &&
          barcode == other.barcode &&
          nome == other.nome &&
          unidadeMedida == other.unidadeMedida &&
          quantidade == other.quantidade &&
          valor == other.valor &&
          imagem == other.imagem &&
          qtdProduto == other.qtdProduto;

  @override
  int get hashCode =>
      barcode.hashCode ^
      nome.hashCode ^
      unidadeMedida.hashCode ^
      quantidade.hashCode ^
      valor.hashCode ^
      imagem.hashCode ^
      qtdProduto.hashCode;
}

List<ProdutoAtivoModel> listData = [];
