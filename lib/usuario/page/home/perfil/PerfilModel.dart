import 'dart:async';

import 'package:cardapio/api/Api.dart';
import 'package:cardapio/api/controller/UserController.dart';
import 'package:cardapio/api/model/DadosPessoais.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'PerfilView.dart';

abstract class PerfilModel extends State<PerfilView> {
  UserController userController = UserController();
  GetIt it = GetIt.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<DadosPessoais> loadPerfil() async {
    try {
      DadosPessoais dados =
          await (userController.getPerfil() as FutureOr<DadosPessoais>);
      print(dados.toJson());
      if (dados != null) {
        return dados;
      } else {
        //var nome = await (storage.read(key: "nome") as FutureOr<String>);
        return DadosPessoais(nome: "Cardapp");
      }
    } catch (e) {
      //var nome = await storage.read(key: "nome");
      return DadosPessoais(nome: "Cardapp");
    }
  }
}
