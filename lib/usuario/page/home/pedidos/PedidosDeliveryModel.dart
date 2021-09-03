import 'package:cardapio/api/controller/DeliveryController.dart';
import 'package:cardapio/usuario/model/Delivery.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:cardapio/usuario/page/home/pedidos/PedidosDelivery.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

abstract class PedidosDeliveryModel extends State<PedidosDelivery> {
  GetIt it = GetIt.instance;
  NumberFormat formatCurrency =
      NumberFormat.currency(locale: "pt_BR", symbol: "R\$", decimalDigits: 2);
  DateFormat formatDate = DateFormat.Hm();
  DeliveryController deliveryController = DeliveryController();
  load() async {
    try {
      List list = await deliveryController.loadPedidos();

      return list;
    } catch (e) {
      return null;
    }
  }

  Future<void> refresh() {
    return Future.delayed(Duration(milliseconds: 200), () {
      setState(() {});
    });
  }

  getTotal(Delivery pedido) {
    var total = 0.0;

    for (PedidoDelivery p in pedido.pedidos!) {
      total += p.produto!.preco! * p.quantidade!;
    }
    total += pedido.tax!.toDouble();
    return formatCurrency.format(total);
  }

  getStatus(Delivery pedido) {
    int? status = 4;
    for (PedidoDelivery p in pedido.pedidos!) {
      if (p.status! <= status!) status = p.status;
    }

    return status;
  }
}
