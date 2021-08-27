import 'dart:convert';

import 'package:cardapio/api/model/Categoria.dart';
import 'package:cardapio/api/model/Produto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../Api.dart';

class ProdutoController {
  FlutterSecureStorage storage = FlutterSecureStorage();

  var host = HOST + "/produto";

  token() async {
    return await storage.read(key: "token");
  }

  save(nome, desc, preco, Categoria categoria, image, Produto produto) async {
    try {
      if (produto != null) {
        Response response = await http.patch(Uri.parse(host), body: {
          "nome": nome,
          "descricao": desc,
          "preco": preco,
          "categoria": jsonEncode(categoria.toJson()),
          "image": image.toString(),
          "id": produto.sId
        }, headers: {
          "token": await token()
        });

        if (response.statusCode == 200) {
          return true;
        } else
          return false;
      } else {
        Response response = await http.post(Uri.parse(host), body: {
          "nome": nome,
          "descricao": desc,
          "preco": preco,
          "categoria": jsonEncode(categoria.toJson()),
          "image": image.toString()
        }, headers: {
          "token": await token()
        });

        if (response.statusCode == 200) {
          return true;
        } else
          return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  produtos() async {
    try {
      Response response =
          await http.get(Uri.parse(host), headers: {"token": await token()});

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Produto> produtos = [];

        for (var c in json) {
          produtos.add(Produto.fromJson(c));
        }
        return produtos;
      } else
        return null;
    } catch (e) {
      print("Produto list " + e.toString());
      return null;
    }
  }

  delete(Produto produto) async {
    try {
      Response response = await http.delete(Uri.parse(host + "/${produto.sId}"),
          headers: {"token": await token()});

      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (e) {
      return false;
    }
  }

  createCategory(Categoria categoria) async {
    try {
      Response response = await http.post(Uri.parse("$host/category"), body: {
        "nome": categoria.nome,
        "preparar": categoria.preparar.toString()
      }, headers: {
        "token": await token()
      });

      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  listCategorys() async {
    try {
      Response response = await http
          .get(Uri.parse("$host/category"), headers: {"token": await token()});

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Categoria> categorys = [];

        for (var c in json) {
          categorys.add(Categoria.fromJson(c));
        }
        return categorys;
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
