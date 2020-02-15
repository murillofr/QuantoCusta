import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quanto_custa/listaProdutosPage.dart';

final GlobalKey<AnimatedListState> _listKey = GlobalKey();

class ProdutosAtivos extends StatefulWidget {
  final ValueChanged<double> parentAction;

  const ProdutosAtivos({
    Key key,
    this.parentAction,
  }) : super(key: key);

  @override
  ProdutosAtivosState createState() => ProdutosAtivosState();

  static addProduto(
      Map<String, String> produto, int qtdProduto, double valorTotalProduto) {
    int index = listData.length;
    int indexEncontrado;

    for (var i = 0; i < listData.length; i++) {
      if (produto["barcode"] == listData[i].barcode) {
        indexEncontrado = i;
        break;
      }
    }

    if (indexEncontrado != null) {
      int a = int.parse(listData[indexEncontrado].qtdProduto);
      double b = listData[indexEncontrado].valorTotalProduto;
      listData[indexEncontrado].qtdProduto = (a + qtdProduto).toString();
      listData[indexEncontrado].valorTotalProduto = (b + valorTotalProduto);
    } else {
      listData.add(
        ProdutoAtivoModel(
          barcode: produto["barcode"],
          nome: produto["nome"],
          descricao: produto["descricao"],
          valor: produto["valor"],
          imagem: produto["imagem"],
          qtdProduto: qtdProduto.toString(),
          valorTotalProduto: valorTotalProduto,
        ),
      );
      if (_listKey.currentState != null) {
        _listKey.currentState
            .insertItem(index, duration: Duration(milliseconds: 500));
      }
    }
  }
}

class ProdutosAtivosState extends State<ProdutosAtivos>
    with AutomaticKeepAliveClientMixin<ProdutosAtivos> {
  NumberFormat formatPreco = NumberFormat("#.00", "pt");
  double valorTodosProdutos;

  @override
  bool get wantKeepAlive => true;

  void delProduto(int index) {
    var produto = listData.removeAt(index);
    double teste = 0.0;
    listData.forEach((n) => teste = teste + n.valorTotalProduto);
    widget.parentAction(teste);

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
      duration: Duration(milliseconds: 500),
    );
  }

  Widget _buildItem(ProdutoAtivoModel produto, [int index]) {
    if (index != null) {
      if (index == 0) {
        valorTodosProdutos = 0.0;
      }
      valorTodosProdutos = valorTodosProdutos + produto.valorTotalProduto;
      ListaProdutosPage.atualizarValorFilhoParaPai(valorTodosProdutos);
    }
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {},
          onLongPress: index != null ? () => delProduto(index) : null,
          child: Stack(
            children: <Widget>[
              ListTile(
                dense: true,
                key: ValueKey<ProdutoAtivoModel>(produto),
                title: Text(
                  produto.nome,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                subtitle: Text(
                  produto.descricao +
                      "\nValor Unitário: R\$ " +
                      produto.valor,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 92.0, 0.0),
                leading: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: Offset(0.0, 0.0),
                      )
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(produto.imagem),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  color: Colors.red[400],
                  width: 88.0,
                  padding: EdgeInsets.all(5.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Qtd: ' + produto.qtdProduto,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'R\$',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 9.0,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.0),
                              Expanded(
                                flex: 5,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    formatPreco
                                        .format(produto.valorTotalProduto),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25.0),
                                  ),
                                ),
                              ),
                            ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedList(
      padding: EdgeInsets.only(top: 5.0),
      key: _listKey,
      initialItemCount: listData.length,
      itemBuilder: (BuildContext context, int index, Animation animation) {
        return FadeTransition(
          opacity: animation,
          child: Container(
            child: _buildItem(listData[index], index),
          ),
        );
      },
    );
  }
}

class ProdutoAtivoModel {
  ProdutoAtivoModel({
    this.barcode,
    this.nome,
    this.descricao,
    this.valor,
    this.imagem,
    this.qtdProduto,
    this.valorTotalProduto,
  });
  String barcode;
  String nome;
  String descricao;
  String valor;
  String imagem;
  String qtdProduto;
  double valorTotalProduto;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProdutoAtivoModel &&
          runtimeType == other.runtimeType &&
          barcode == other.barcode &&
          nome == other.nome &&
          descricao == other.descricao &&
          valor == other.valor &&
          imagem == other.imagem &&
          qtdProduto == other.qtdProduto &&
          valorTotalProduto == other.valorTotalProduto;

  @override
  int get hashCode =>
      barcode.hashCode ^
      nome.hashCode ^
      descricao.hashCode ^
      valor.hashCode ^
      imagem.hashCode ^
      qtdProduto.hashCode ^
      valorTotalProduto.hashCode;
}

List<ProdutoAtivoModel> listData = [];
