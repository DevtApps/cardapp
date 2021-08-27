import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import '../Api.dart';
import 'package:http/http.dart' as http;

class FaturamentoController {
  FaturamentoController();

  FlutterSecureStorage storage = FlutterSecureStorage();

  var host = HOST + "/faturamento";
  token() async {
    return await storage.read(key: "token");
  }

  getFaturamento() async {
    try {
      Response response = await http.get(Uri.parse(host), headers: {
        "token": await token()
      }).timeout(Duration(milliseconds: 10000));
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return response;
      } else
        return null;
    } catch (e) {
      return null;
    }
  }
}
