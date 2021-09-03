import 'package:cardapio/api/controller/UserController.dart';
import 'package:cardapio/usuario/page/home/perfil/endereco/model/Endereco.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_place/google_place.dart';

class AddressEdit extends StatefulWidget {
  Endereco address;

  AddressEdit(this.address);
  @override
  _AddressEditState createState() => _AddressEditState(address);
}

class _AddressEditState extends State<AddressEdit> {
  Endereco address;
  _AddressEditState(this.address);

  var places = GooglePlace("apiKEY");

  TextEditingController nome = TextEditingController();
  TextEditingController cidade = TextEditingController();
  TextEditingController uf = TextEditingController();
  TextEditingController bairro = TextEditingController();
  TextEditingController rua = TextEditingController();
  TextEditingController numero = TextEditingController();
  TextEditingController complemento = TextEditingController();

  UserController userController = UserController();

  GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (address != null) {
      /*
      cidade.text = address.subAdminArea;
      var _uf = '';
      address.adminArea.split(" ").forEach((element) {
        _uf += element[0];
      });
      uf.text = _uf;
      rua.text = address.thoroughfare;
      numero.text = address.subThoroughfare;
      */
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      appBar: AppBar(
        title: Text("Complete Endereço"),
        brightness: Brightness.dark,
      ),
      body: Form(
        key: _form,
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Container(
                        child: TextFormField(
                          validator: (str) {
                            return str!.length >= 3
                                ? null
                                : "Informe um nome para o endereço";
                          },
                          controller: nome,
                          decoration: InputDecoration(
                              filled: true, hintText: "Nome (ex: casa)"),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: TextFormField(
                          validator: (str) {
                            return str!.length >= 3 ? null : "Bairro inválido";
                          },
                          controller: bairro,
                          decoration:
                              InputDecoration(filled: true, hintText: "Bairro"),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: TextFormField(
                          validator: (str) {
                            return str!.length >= 3 ? null : "Rua inválida";
                          },
                          controller: rua,
                          decoration:
                              InputDecoration(filled: true, hintText: "Rua"),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                          child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (str) {
                                return str!.length >= 1
                                    ? null
                                    : "Número inválido";
                              },
                              controller: numero,
                              decoration: InputDecoration(
                                  filled: true, hintText: "Número"),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextField(
                              controller: complemento,
                              decoration: InputDecoration(
                                  filled: true, hintText: "Complemento"),
                            ),
                          )
                        ],
                      )),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                validator: (str) {
                                  return str!.length >= 3
                                      ? null
                                      : "Cidade inválida";
                                },
                                controller: cidade,
                                decoration: InputDecoration(
                                    filled: true, hintText: "Cidade"),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                validator: (str) {
                                  return str!.length >= 2 ? null : "UF inválido";
                                },
                                controller: uf,
                                decoration: InputDecoration(
                                    filled: true, hintText: "UF"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                width: double.infinity,
                child: TextButton(
                  child: Text("Salvar"),
                  onPressed: () async {
                    if (_form.currentState!.validate()) {
                      Endereco endereco = Endereco(
                          nome.text,
                          rua.text,
                          numero.text,
                          bairro.text,
                          cidade.text,
                          uf.text,
                          0, //address.coordinates.latitude,
                          0, //address.coordinates.longitude,
                          "${rua.text}, ${numero.text}, ${cidade.text} - ${uf.text}");
                      var result =
                          await userController.adicionarEndereco(endereco);
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Verifique sua conexão com a internet")));
                      } else if (!result) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Verifique os dados e tente novamente")));
                      } else {
                        Navigator.of(context).pop(true);
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
