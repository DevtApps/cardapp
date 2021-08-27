import 'Categoria.dart';

class Produto {
  String sId;
  String nome;
  double preco;
  String descricao;
  Categoria categoria;
  String image;
  String gerente;

  Produto({this.sId, this.nome, this.preco, this.descricao, this.categoria});

  Produto.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nome = json['nome'];
    preco = json['preco'].toDouble();
    descricao = json['descricao'];
    categoria = Categoria.fromJson(json['categoria']);
    image = json['image'];
    gerente = json['gerente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['nome'] = this.nome;
    data['preco'] = this.preco;
    data['descricao'] = this.descricao;
    data['categoria'] = this.categoria.toJson();
    data['gerente'] = this.gerente;
    return data;
  }
}
