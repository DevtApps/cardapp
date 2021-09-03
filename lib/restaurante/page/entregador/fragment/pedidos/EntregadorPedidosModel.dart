import 'package:cardapio/api/controller/DeliveryController.dart';
import 'package:cardapio/usuario/model/Delivery.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'EntregadorPedidosView.dart';

abstract class EntregadorPedidosModel extends State<EntregadorPedidosView> {
  var changePage;

  EntregadorPedidosModel(this.changePage);
  DeliveryController deliveryController = DeliveryController();
  NumberFormat currency = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

  loadDeliveries() async {
    try {
      var list = await deliveryController.loadDeliveries();
      return list;
    } catch (e) {
      return null;
    }
  }

  Future refresh() async {
    setState(() {});
    return await Future.delayed(Duration(seconds: 1), () {
      return;
    });
  }

  getTotalCurrency(List<PedidoDelivery> pedidos, double tax) {
    var total = 0.0;

    for (var item in pedidos) {
      total += item.quantidade! * item.produto!.preco!;
    }
    total += tax;
    return currency.format(total);
  }

  String getPaymentType(Delivery delivery) {
    switch (delivery.payment) {
      case "money":
        return "Receber em dinheiro";
      case "machine":
        return "Receber com maquininha";
      default:
        return "Pago pelo aplicativo";
    }
  }

  entregar(Delivery delivery) async {
    var result = await showModalBottomSheet(
        context: context,
        builder: (c) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Pegar Entrega"),
                  onTap: () async {
                    await deliveryController.statusDelivery(1, delivery.sId);
                    Navigator.of(c).pop(true);
                  },
                ),
                ListTile(
                  title: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(c).pop();
                  },
                ),
              ],
            ),
          );
        });
    if (result != null) {
      changePage(1);
    }
  }
}
