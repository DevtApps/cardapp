import 'dart:convert';

import 'package:cardapio/api/socket/NotificationManager.dart';
import 'package:cardapio/usuario/model/Delivery.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:cardapio/usuario/page/home/perfil/endereco/model/Endereco.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

import '../Api.dart';

class DeliveryController {
  GetIt it = GetIt.instance;
  FlutterSecureStorage storage = FlutterSecureStorage();

  var host = HOST + "/delivery";

  token() async {
    return await storage.read(key: "token");
  }

  novoPedido(List<PedidoDelivery> pedidos, Endereco endereco, String? payment,
      double tax) async {
    try {
      var delivery = Map();
      delivery['payment'] = payment;
      delivery['tax'] = tax;
      var itens = [];
      for (var pedido in pedidos) {
        itens.add(pedido.toJson());
      }

      delivery['pedidos'] = itens;
      delivery['endereco'] = endereco.toJson();

      Response response = await post(Uri.parse("$host/pedido"),
          body: jsonEncode(delivery), headers: {"token": await token()});
      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  loadPedidos() async {
    try {
      Response result = await get(Uri.parse(host + "/pedidos"),
          headers: {"token": await token()});

      if (result.statusCode == 200) {
        List<Delivery> deliveries = [];
        var json = jsonDecode(result.body);

        for (var delivery in json) {
          deliveries.add(Delivery.fromJson(delivery));
        }

        deliveries.sort((a, b) => a.createdAt.isBefore(b.createdAt) ? 1 : 0);
        return deliveries;
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Delivery>?> loadDeliveries({entregas}) async {
    try {
      Response result = await get(
          Uri.parse(host + "/deliveries?entregas=${entregas}"),
          headers: {"token": await token()});

      if (result.statusCode == 200) {
        List<Delivery> deliveries = [];
        var json = jsonDecode(result.body);

        for (var delivery in json) {
          deliveries.add(Delivery.fromJson(delivery));
        }

        deliveries.sort((a, b) => a.createdAt.isBefore(b.createdAt) ? 1 : 0);
        return deliveries;
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  statusPedido(stats, pedido, {notify}) async {
    try {
      print(pedido.delivery);
      Response result = await patch(Uri.parse(host + "/pedido/status"), body: {
        "status": stats.toString(),
        "pedido": pedido.sId,
        "delivery": pedido.delivery
      }, headers: {
        "token": await token()
      });

      print(result.body);
      if (result.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  statusDelivery(stats, delivery, {notify}) async {
    try {
      Response result = await patch(Uri.parse(host + "/status"),
          body: {"status": stats.toString(), "delivery": delivery},
          headers: {"token": await token()});

      if (result.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
