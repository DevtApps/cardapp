import 'package:cardapio/api/controller/DeliveryController.dart';
import 'package:cardapio/api/secure/ModelUser.dart';
import 'package:cardapio/api/socket/NotificationManager.dart';
import 'package:cardapio/usuario/model/Delivery.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:cardapio/usuario/page/home/pedidos/PedidosDeliveryModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PedidosDelivery extends StatefulWidget {
  @override
  _PedidosDeliveryState createState() => _PedidosDeliveryState();
}

class _PedidosDeliveryState extends PedidosDeliveryModel {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<NotificationManager>(
      create: (context) => new NotificationManager(),
      child: Consumer<NotificationManager>(builder: (context, model, _) {
        return body();
      }),
    );
  }

  Widget body() {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder(
          builder: (c, snap) {
            if (snap.hasData) {
              List<Delivery>? list = snap.data as List<Delivery>;
              return ListView.builder(
                itemBuilder: (c, i) {
                  return Card(
                    margin: EdgeInsets.all(4),
                    child: Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Estamos cuidando de seu pedido",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Container(
                                  child: Text(
                                    formatDate
                                        .format(list![i].createdAt.toLocal()),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              child: Text("Detalhes"),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 14, right: 14),
                              child: Text(
                                list[i]?.endereco?.formatted ?? "",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(list[i].pedidos!.length,
                                  (index) {
                                PedidoDelivery pedido = list[i].pedidos![index];
                                return ListTile(
                                  contentPadding:
                                      EdgeInsets.only(left: 16, right: 16),
                                  dense: true,
                                  title: Text(
                                      list[i].pedidos![index].produto!.nome!),
                                  trailing: Text(
                                      "${pedido.quantidade} x ${formatCurrency.format(pedido.produto!.preco! * pedido.quantidade!)}"),
                                );
                              }),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.only(
                                  left: 16, right: 16, top: 0, bottom: 0),
                              dense: true,
                              title: Text(
                                "Tax. entrega",
                              ),
                              trailing: Text(
                                formatCurrency.format(list[i].tax),
                              ),
                            ),
                            ListTile(
                              contentPadding:
                                  EdgeInsets.only(left: 16, right: 16),
                              dense: true,
                              title: Text(
                                "Total",
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: Text(
                                getTotal(list[i]),
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              child: titleStatus(getStatus(list[i])),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: size.width * 0.25,
                                  height: 2,
                                  color: getStatus(list[i]) >= 0
                                      ? Colors.orange
                                      : Colors.grey,
                                  margin: EdgeInsets.only(left: 4, right: 4),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: 2,
                                  color: getStatus(list[i]) >= 1
                                      ? Colors.orange
                                      : Colors.grey,
                                  margin: EdgeInsets.only(left: 4, right: 4),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: 2,
                                  color: getStatus(list[i]) >= 2
                                      ? Colors.orange
                                      : Colors.grey,
                                  margin: EdgeInsets.only(left: 4, right: 4),
                                )
                              ],
                            )
                          ],
                        )),
                  );
                },
                itemCount: list.length,
              );
            } else if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: Shimmer(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey, Colors.white30]),
                    child: ListView()),
              );
            } else
              return Center(
                child: Text("Nenhum pedido encontrado"),
              );
          },
          future: load(),
        ),
      ),
    );
  }

  Widget titleStatus(status) {
    switch (status) {
      case 0:
        {
          return Text("Recebemos seu pedido");
        }
      case 1:
        {
          return Text("Seu pedido está sendo preparado");
        }
      case 2:
        {
          return Text("Aguardando entrega");
        }
      case 3:
        {
          return Text("Pedido Entregue");
        }
      default:
        return Text("Recebemos seu pedido");
    }
  }
}
