class Mesa {
  var numero;
  var id;
  var itens;
  var atendente;

  Mesa.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    numero = json['numero'];
    itens = json['itens'];
    atendente = json['atendente'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['numero'] = this.numero;
    data['itens'] = this.itens;
    data ['atendente'] = this.atendente;

    return data;
  }
}
