class User {
  String sId;
  String email;
  String senha;
  String type;
  String nome;
  int iV;

  User({this.sId, this.email, this.senha, this.type, this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    senha = json['senha'];
    type = json['type'];
    nome = json['nome'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['nome'] = this.nome;
    data['__v'] = this.iV;
    data['type'] = this.type;
    return data;
  }
}
