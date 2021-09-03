import 'dart:convert';

import 'package:cardapio/api/model/Mesa.dart';
import 'package:cardapio/api/model/Pedido.dart';
import 'package:cardapio/api/model/Produto.dart';
import 'package:cardapio/api/socket/NotificationManager.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../Api.dart';

class MesaController {
  GetIt it = GetIt.instance;
  FlutterSecureStorage storage = FlutterSecureStorage();

  var host = HOST + "/mesa";

  token() async {
    return await storage.read(key: "token");
  }

  novaMesa(numero, Mesa? mesa) async {
    try {
      String? id = "";
      if (mesa != null) id = mesa.id;
      Response response = await http.post(Uri.parse(host),
          body: {"numero": numero, "id": id},
          headers: {"token": await token()});
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (ex) {
      return false;
    }
  }

  delete(Mesa mesa) async {
    try {
      Response response = await http.delete(Uri.parse("$host/${mesa.id}"),
          headers: {"token": await token()});
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (ex) {
      return false;
    }
  }

  mesas() async {
    try {
      Response response =
          await http.get(Uri.parse(host), headers: {"token": await token()});

      if (response.statusCode == 200) {
        var mesas = [];
        var body = jsonDecode(response.body);
        for (var mesa in body) {
          mesas.add(Mesa.fromJson(mesa));
        }
        return mesas;
      } else
        return null;
    } catch (ex) {
      return null;
    }
  }

  novoPedido(List<Pedido?> pedidos) async {
    try {
      var itens = [];
      for (var pedido in pedidos) {
        itens.add(pedido!.toJson());
      }
      Response response = await http.post(Uri.parse("$host/pedido"),
          body: jsonEncode(itens), headers: {"token": await token()});

      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  atualizarPedido(qtd, obs, Produto produto, id, idPedido) async {
    try {
      Response response = await http.patch(Uri.parse("$host/pedido"), body: {
        "quantidade": qtd.toString(),
        "observacao": obs,
        "produto": jsonEncode(produto.toJson()),
        "id": id,
        "pedido": idPedido
      }, headers: {
        "token": await token()
      });

      if (response.statusCode == 200) {
        print("OK");
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  mesa(id) async {
    try {
      Response response = await http
          .get(Uri.parse("$host/$id"), headers: {"token": await token()});

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return Mesa.fromJson(body);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  deletePedido(id, pedidoid) async {
    try {
      Response response = await http.delete(
          Uri.parse("$host/pedido/$id/$pedidoid"),
          headers: {"token": await token()});
      print(response.statusCode);
      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (ex) {
      return false;
    }
  }

  loadPedidos() async {
    try {
      Response result = await http
          .get(Uri.parse(host + "/pedidos"), headers: {"token": await token()});

      print(result.body);
      if (result.statusCode == 200) {
        List<dynamic> pedidos = [];
        var json = jsonDecode(result.body);
        for (var pedido in json['local']) {
          pedidos.add(Pedido.fromJson(pedido));
        }
        for (var pedido in json['delivery']) {
          pedidos.add(PedidoDelivery.fromJson(pedido));
        }

        return pedidos;
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  status(stats, mesa, idPedido, {notify}) async {
    try {
      Response result = await http.patch(Uri.parse(host + "/pedido/status"),
          body: {"status": stats.toString(), "id": mesa, "pedido": idPedido},
          headers: {"token": await token()});

      if (result.statusCode == 200) {
        if (notify != false) {}
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  clear(id) async {
    try {
      Response response = await http.delete(Uri.parse("$host/pedidos/$id"),
          headers: {"token": await token()});
      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (e) {
      return false;
    }
  }
}
