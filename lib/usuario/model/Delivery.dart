import 'dart:convert';

import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:cardapio/usuario/page/home/perfil/endereco/model/Endereco.dart';
import 'package:flutter/cupertino.dart';

class Delivery {
  String? sId;
  int? status;
  String? usuario;
  double? tax;
  late DateTime createdAt;
  Endereco? endereco;
  String? payment;
  String? entregador;
  String? nome;

  List<PedidoDelivery>? pedidos = [];
  Delivery({this.usuario, this.pedidos});

  Delivery.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    entregador = json['entregador'];
    payment = json['payment'];
    status = json['status'];
    usuario = json['usuario'] ?? json['usuario'];
    nome = json['nome'];
    tax = json['tax'].toDouble();
    endereco = Endereco.fromJson(json['endereco']);
    createdAt = DateTime.parse(json['createdAt']);

    if (json['pedidos'].length > 0) {
      for (var p in json['pedidos']) {
        pedidos!.add(PedidoDelivery.fromJson(p));
      }
    }
  }
}
