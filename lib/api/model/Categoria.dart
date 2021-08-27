class Categoria {
  String sId;
  String nome;
  bool active = false;
  bool preparar = false;

  Categoria({this.sId, this.nome, this.preparar});

  Categoria.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nome = json['nome'];
    preparar = json['preparar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['nome'] = this.nome;
    data['preparar'] = this.preparar;
    return data;
  }
}
