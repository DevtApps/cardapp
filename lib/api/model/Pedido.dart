import 'package:cardapio/api/model/Produto.dart';

class Pedido {
  String? sId;
  String? observacao;
  Produto? produto;
  int? quantidade;
  int? status = 0;
  String? mesa;
  String? type;

  Pedido(
      {this.sId,
      this.observacao,
      this.produto,
      this.quantidade,
      this.mesa,
      this.status});

  Pedido.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    observacao = json['observacao'];
    produto = Produto.fromJson(json['produto']);
    quantidade = json['quantidade'];
    status = json['status'];
    mesa = json['mesa'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['observacao'] = this.observacao;
    data['produto'] = this.produto!.toJson();
    data['quantidade'] = this.quantidade;
    data['status'] = this.status;
    data['mesa'] = this.mesa;

    return data;
  }
}
