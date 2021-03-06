import 'package:cardapio/api/controller/MesaController.dart';
import 'package:cardapio/api/model/Pedido.dart';
import 'package:cardapio/api/model/Produto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DialogPedido extends StatefulWidget {
  Produto? item;
  var mesa;
  var pedindo;
  var pedido;

  DialogPedido(this.item, this.mesa, {this.pedido, this.pedindo});
  @override
  _DialogPedidoState createState() =>
      _DialogPedidoState(item, mesa, pedido: pedido, pedindo: pedindo);
}

class _DialogPedidoState extends State<DialogPedido> {
  int? qtd = 1;
  Produto? item;
  var mesa;
  var pedindo;
  Pedido? pedido;

  MesaController mesaController = MesaController();

  TextEditingController obsController = TextEditingController();
  _DialogPedidoState(this.item, this.mesa, {this.pedido, this.pedindo});

  double? valor = 0.0;

  NumberFormat format =
      NumberFormat.currency(locale: "pt_BR", symbol: "R\S", decimalDigits: 2);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valor = item!.preco;

    if (pedido != null) {
      try {
        setState(() {
          valor = pedido!.quantidade! * pedido!.produto!.preco!;
          qtd = pedido!.quantidade;
          obsController.text = pedido!.observacao!;
        });
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.4),
        body: ListView(
          children: [
            Center(
              child: Card(
                margin: EdgeInsets.all(28),
                child: Container(
                  padding: EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item!.nome!,
                        style: TextStyle(fontSize: size.width * 0.05),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Valor: ${format.format(valor)}",
                        style: TextStyle(fontSize: size.width * 0.04),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (qtd! > 1) {
                                qtd = qtd! - 1;
                                valor = qtd! * item!.preco!;
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 25, right: 25, top: 4, bottom: 4),
                            child: Text(
                              "-",
                              style: TextStyle(
                                  fontSize: size.width * 0.06,
                                  color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                          ),
                        ),
                        Expanded(
                          child: Center(
                              child: Text(
                            "Unidades $qtd",
                            style: TextStyle(
                              fontSize: size.width * 0.05,
                            ),
                          )),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                qtd = qtd! + 1;
                                valor = qtd! * item!.preco!;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 25, right: 25, top: 4, bottom: 4),
                              child: Text(
                                "+",
                                style: TextStyle(
                                    fontSize: size.width * 0.06,
                                    color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                            )),
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: obsController,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.none,
                        maxLines: 5,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: "Observa????o",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            color: Colors.orange,
                            child: Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(null);
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FlatButton(
                            color: Colors.orange,
                            child: Text(
                                pedido == null ? "Adicionar" : "Atualizar",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              if (pedido != null && pedindo != true) {
                                var r = await mesaController.atualizarPedido(
                                    qtd,
                                    obsController.text,
                                    item!,
                                    mesa.id,
                                    pedido!.sId);
                                if (r) Navigator.of(context).pop(null);
                              } else {
                                var status = 0;
                                if (!item!.categoria!.preparar!) status = 2;
                                Navigator.of(context).pop(Pedido(
                                    quantidade: qtd,
                                    observacao: obsController.text,
                                    mesa: mesa.id,
                                    produto: item,
                                    status: status));
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
