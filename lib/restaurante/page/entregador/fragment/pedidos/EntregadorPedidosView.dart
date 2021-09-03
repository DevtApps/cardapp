import 'package:cardapio/api/socket/NotificationManager.dart';
import 'package:cardapio/usuario/model/Delivery.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'EntregadorPedidosModel.dart';

class EntregadorPedidosView extends StatefulWidget {
  var changePage;

  EntregadorPedidosView(this.changePage);
  @override
  _EntregadorPedidosViewState createState() =>
      _EntregadorPedidosViewState(this.changePage);
}

class _EntregadorPedidosViewState extends EntregadorPedidosModel {
  _EntregadorPedidosViewState(changePage) : super(changePage);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotificationManager>(
      create: (context) => new NotificationManager(),
      child: Consumer<NotificationManager>(builder: (context, model, _) {
        return body();
      }),
    );
  }

  Widget body() {
    return Scaffold(
      body: FutureBuilder(
        builder: (c, snap) {
          if (snap.hasData) {
            List<Delivery>? list = snap.data as List<Delivery>;
            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                itemBuilder: (c, i) {
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(list[i].nome!),
                        ),
                        Container(
                          child: Column(
                            children: List.generate(
                              list[i].pedidos!.length,
                              (index) {
                                List<PedidoDelivery> pedidos = list[i].pedidos!;
                                return Container(
                                  margin: EdgeInsets.only(left: 16, right: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        pedidos[index].produto!.nome!,
                                      ),
                                      Text(
                                          "${pedidos[index].quantidade} x ${currency.format(pedidos[index].produto!.preco)}"),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tax. Entrega"),
                              Text(currency.format(list[i].tax))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("TOTAL"),
                              Text(getTotalCurrency(
                                  list[i].pedidos!, list[i].tax!))
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text("Pagamento:"),
                          subtitle: Text(getPaymentType(list[i])),
                        ),
                        Container(
                          child: Text("Entregar em:"),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                        ),
                        ListTile(
                          title: Text(list[i].endereco!.formatted),
                          onTap: () {},
                        ),
                        Container(
                          child: TextButton(
                              child: Text("Entregar Pedidos"),
                              onPressed: () {
                                entregar(list[i]);
                              }),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  );
                },
                itemCount: list.length,
              ),
            );
          } else if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                value: null,
              ),
            );
          } else {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text("Nenhum pedido encontrado"),
                SizedBox(
                  height: 4,
                ),
                TextButton(
                  child: Text("Atualizar"),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ]),
            );
          }
        },
        future: loadDeliveries(),
      ),
    );
  }
}
