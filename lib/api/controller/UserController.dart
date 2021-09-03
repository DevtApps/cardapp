import 'dart:convert';

import 'package:cardapio/api/Api.dart';
import 'package:cardapio/api/model/DadosPessoais.dart';
import 'package:cardapio/api/model/User.dart';
import 'package:cardapio/usuario/page/home/perfil/endereco/model/Endereco.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class UserController {
  FlutterSecureStorage storage = FlutterSecureStorage();

  var host = HOST + "/user";
  token() async {
    return await storage.read(key: "token");
  }

  login(email, senha) async {
    try {
      Response result = await http.post(Uri.parse(host + "/login"),
          body: {"email": email, "senha": senha},
          headers: {"Content-Type": "application/x-www-form-urlencoded"});

      if (result.statusCode == 200) {
        await storage.write(
            key: "token", value: jsonDecode(result.body)['token']);
        await storage.write(
            key: "type", value: jsonDecode(result.body)['type']);
        await storage.write(
            key: "nome", value: jsonDecode(result.body)['nome']);
        if (jsonDecode(result.body)['registro'] == true)
          await storage.write(key: "registro", value: "true");
        return true;
      } else if (result.statusCode == 202) {
        await storage.write(
            key: "token", value: jsonDecode(result.body)['token']);
        await storage.write(
            key: "nome", value: jsonDecode(result.body)['nome']);
        await storage.write(
            key: "type", value: jsonDecode(result.body)['type']);
        if (jsonDecode(result.body)['registro'] == true)
          await storage.write(key: "registro", value: "true");

        return null;
      } else
        return false;
    } catch (ex) {
      return false;
    }
  }

  register(nome, email, senha, type, user) async {
    try {
      String? id = "";
      if (user != null) id = user.sId;
      Response result = await http.post(Uri.parse(host + "/register"), body: {
        "nome": nome,
        "email": email,
        "senha": senha,
        "id": id,
        "type": type
      }, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });

      if (result.statusCode == 200) {
        await storage.write(
            key: "token", value: jsonDecode(result.body)['token']);
        await storage.write(
            key: "type", value: jsonDecode(result.body)['type']);
        return true;
      } else
        return false;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  registerFuncionario(nome, email, senha, type, user) async {
    try {
      String? id = "";
      if (user != null) id = user.sId;
      Response result = await http
          .post(Uri.parse(host + "/register/funcionario"), body: {
        "nome": nome,
        "email": email,
        "senha": senha,
        "type": type,
        "id": id
      }, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "token": await token()
      });

      if (result.statusCode == 200) {
        //storage.write(key: "token", value: jsonDecode(result.body)['token']);
        return true;
      } else
        return false;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  users() async {
    try {
      Response result = await http
          .get(Uri.parse(host + "/users"), headers: {"token": await token()});

      if (result.statusCode == 200) {
        //storage.write(key: "token", value: jsonDecode(result.body)['token']);
        var json = jsonDecode(result.body);
        List<User> users = [];
        for (var user in json) {
          users.add(User.fromJson(user));
        }

        return users;
      } else
        return null;
    } catch (ex) {
      return null;
    }
  }

  delete(id) async {
    try {
      Response result = await http
          .delete(Uri.parse(host + "/$id"), headers: {"token": await token()});
      print(result);
      if (result.statusCode == 200) {
        return true;
      } else
        return false;
    } catch (ex) {
      return false;
    }
  }

  preDados(nome, cpf) async {
    try {
      Response result = await http.post(Uri.parse(host + "/precadastro"),
          body: {"nome": nome, "cpf": cpf},
          headers: {"token": await token(), "preRegistro": "1"});
      print(result);
      if (result.statusCode == 200) {
        await storage.write(key: "registro", value: "true");
        return true;
      } else if (result.statusCode == 400)
        return null;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  adicionarEndereco(Endereco endereco) async {
    print(endereco.toJson());
    try {
      Response result = await http.post(Uri.parse(host + "/endereco"),
          body: endereco.toJson(),
          headers: {"token": await token()},
          encoding: Encoding.getByName("utf8"));

      print(result.body);
      if (result.statusCode == 200) {
        return true;
      } else if (result.statusCode == 400)
        return null;
      else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  getEnderecos() async {
    try {
      Response result = await http.get(
        Uri.parse(host + "/endereco"),
        headers: {"token": await token()},
      );

      if (result.statusCode == 200) {
        List<Endereco> list = [];

        var json = jsonDecode(result.body);
        for (var address in json) {
          list.add(Endereco.fromJson(address));
        }

        return list;
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  deleteAddres(id) async {
    try {
      Response result = await http.delete(
        Uri.parse(host + "/endereco/"+id),
        headers: {"token": await token()},
      );
      print(result.body);

     return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<DadosPessoais?> getPerfil() async {
    try {
      Response result = await http.get(
        Uri.parse(host + "/perfil"),
        headers: {"token": await token()},
      );


      if (result.statusCode == 200) {
        var json = jsonDecode(result.body);
        var dados = DadosPessoais.fromJson(json);

        return dados;
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
  Future<bool> updatePerfil(String nome, String cpf) async {
    try {
      Response result = await http.patch(
        Uri.parse(host + "/perfil"),
        body: {
          "nome":nome,
          "cpf":cpf
        },
        headers: {"token": await token()},
      );
     return result.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
