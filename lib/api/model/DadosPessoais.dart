class DadosPessoais {
  String? sId;
  String? nome;
  String? cpf;
  String? email;
  String? account;
  String? createdAt;
  String? updatedAt;
  String? picture;

  DadosPessoais(
      {this.sId,
      this.nome,
      this.cpf,
      this.email,
      this.account,
      this.createdAt,
      this.updatedAt,
      this.picture});

  DadosPessoais.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    nome = json['nome'];
    cpf = json['cpf'];
    email = json['email'];
    account = json['account'];
    picture = json['picture'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['email'] = this.email;
    data['account'] = this.account;
    data['picture'] = this.picture;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
