import 'dart:convert';

class Endereco {
  var id;
  var nome;
  var usuario;
  var rua;
  var bairro;
  var cidade;
  var numero;
  var uf;
  var cep;
  var lat;
  var lng;
  var complemento;
  var formatted;

  Endereco(this.nome, this.rua, this.numero, this.bairro, this.cidade, this.uf,
      this.lat, this.lng, this.formatted,
      {this.cep, this.complemento});

  Endereco.fromJson(Map<dynamic, dynamic> map) {
    this.id = map['_id'];
    this.nome = map['nome'];
    this.usuario = map['usuario'];
    this.rua = map['rua'];
    this.bairro = map['bairro'];
    this.cidade = map['cidade'];
    this.uf = map['uf'];
    this.cep = map['cep'];
    this.lat = map['lat'];
    this.lng = map['lng'];
    this.complemento = map['complemento'];
    this.numero = map['numero'];
    this.formatted = map['formatted'];

  }

  toJson() {
    Map<dynamic, dynamic> map = Map();
    map['nome'] = this.nome;
    map['usuario'] = this.usuario;
    map['rua'] = this.rua;
    map['bairro'] = this.bairro;
    map['cidade'] = this.cidade;
    map['uf'] = this.uf;
    map['cep'] = this.cep;
    map['lat'] = this.lat;
    map['lng'] = this.lng;
    map['complemento'] = this.complemento;
    map['formatted'] = this.formatted;
    map['numero'] = this.numero;
    return jsonEncode(map);
  }
}
