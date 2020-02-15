import 'package:flutter/material.dart';

final GlobalKey<AnimatedListState> _listKey = GlobalKey();

class ProdutosHistorico extends StatefulWidget {
  const ProdutosHistorico({
    Key key,
  }) : super(key: key);

  @override
  ProdutosHistoricoState createState() => ProdutosHistoricoState();

  static addProduto(Map<String, String> produto, String data, String hora) {
    int index = listData.length;
    int indexEncontrado;

    for (var i = 0; i < listData.length; i++) {
      if (produto["barcode"] == listData[i].barcode) {
        indexEncontrado = i;
        break;
      }
    }

    if (indexEncontrado != null) {
      listData[indexEncontrado].data = data;
      listData[indexEncontrado].hora = hora;
    } else {
      listData.add(
        ProdutoAtivoModel(
          barcode: produto["barcode"],
          nome: produto["nome"],
          descricao: produto["descricao"],
          valor: produto["valor"],
          imagem: produto["imagem"],
          data: data,
          hora: hora,
        ),
      );
      if (_listKey.currentState != null) {
        _listKey.currentState
            .insertItem(index, duration: Duration(milliseconds: 500));
      }
    }
  }
}

class ProdutosHistoricoState extends State<ProdutosHistorico>
    with AutomaticKeepAliveClientMixin<ProdutosHistorico> {
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
      duration: Duration(milliseconds: 500),
    );
  }

  Widget _buildItem(ProdutoAtivoModel produto, [int index]) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {},
          //onLongPress: index != null ? () => delProduto(index) : null,
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
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              produto.data,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              produto.hora,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15.0),
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
    this.data,
    this.hora,
  });
  String barcode;
  String nome;
  String descricao;
  String valor;
  String imagem;
  String data;
  String hora;

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
          data == other.data &&
          hora == other.hora;

  @override
  int get hashCode =>
      barcode.hashCode ^
      nome.hashCode ^
      descricao.hashCode ^
      valor.hashCode ^
      imagem.hashCode ^
      data.hashCode ^
      hora.hashCode;
}

List<ProdutoAtivoModel> listData = [];
