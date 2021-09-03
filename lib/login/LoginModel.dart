import 'dart:async';

import 'package:cardapio/api/controller/UserController.dart';
import 'package:cardapio/api/socket/ConnectionManager.dart';
import 'package:cardapio/fastfire/models/SocialSignInModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'LoginView.dart';

abstract class LoginModel extends State<LoginView> with SocialSignInModel {
  @override
  void onSuccess(UserCredential credential) {}

  @override
  void onError(Exception error, int code) {
    // TODO: implement onError
  }

  var args;
  var toggle = true;
  var icon = Icons.lock;

  TextEditingController email = TextEditingController();
  var senha = TextEditingController();
  var userController = new UserController();

  FlutterSecureStorage storage = FlutterSecureStorage();
  GetIt it = GetIt.instance;
  double? value = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
  }

  login() async {
    if (email.text.contains("@") && senha.text.length > 5) {
      setState(() {
        value = null;
      });
      var user = await userController.login(email.text, senha.text);

      if (user == null) {
        var token = await (storage.read(key: "token") as FutureOr<String>);
        it.registerSingleton(new ConnectionManager(token));
        Navigator.of(context).pushReplacementNamed("inativo");
        return;
      }
      if (user == false) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Dados Incorretos!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red));
      } else {
        var token = await storage.read(key: "token");
        //it.registerSingleton(new ModelUser(token));
        var type = await storage.read(key: "type");
        it.registerSingleton(new ConnectionManager(token));

        var registro = await storage.read(key: "registro");
        if (registro == null && type == "gerente") {
          Navigator.of(context).pushReplacementNamed("precadastro");
          return;
        }
        if (type == "admin" || type == "gerente")
          Navigator.of(context).pushReplacementNamed("painel");
        else if (type == "garcom")
          Navigator.of(context).pushReplacementNamed("home");
        else if (type == "cozinha")
          Navigator.of(context).pushReplacementNamed("cozinha");
        else if (type == "user")
          Navigator.of(context).pushReplacementNamed("home_user");
        else if (type == "entregador")
          Navigator.of(context).pushReplacementNamed("entregador");
      }
      setState(() {
        value = 0.0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Preencha os dados!", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange));
    }
  }
}
