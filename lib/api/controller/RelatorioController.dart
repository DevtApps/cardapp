import 'dart:convert';

import 'package:cardapio/api/Api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class RelatorioController {
  FlutterSecureStorage storage = FlutterSecureStorage();

  var host = HOST + "/relatorio";
  token() async {
    return await storage.read(key: "token");
  }

  loadRelatorio(date) async {
    try {
      Response response = await http.get(Uri.parse("$host?data=$date"),
          headers: {"token": await token()});

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        return json;
      } else
        return null;
    } catch (ex) {
      return null;
    }
  }

  loadRelatorioMensal() async {
    try {
      Response response = await http
          .get(Uri.parse("$host/diadia"), headers: {"token": await token()});

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        return json;
      } else
        return null;
    } catch (ex) {
      return null;
    }
  }
}
