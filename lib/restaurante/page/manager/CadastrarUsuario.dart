import 'package:cardapio/api/controller/UserController.dart';
import 'package:cardapio/api/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastrarUsuario extends StatefulWidget {
  User? user;
  CadastrarUsuario({this.user});
  @override
  _CadastrarUsuarioState createState() => _CadastrarUsuarioState(user: user);
}

class _CadastrarUsuarioState extends State<CadastrarUsuario> {
  User? user;
  _CadastrarUsuarioState({this.user});
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  Map<String, String>? selected = {"nome": "Selecione uma categoria", "value": ""};
  UserController controller = UserController();

  var _toggle = true;
  var icon = Icons.lock;
  var categorias = [
    //{"nome": "Gerente", "value": "gerente"},
    {"nome": "Garçom", "value": "garcom"},
    {"nome": "Cozinha", "value": "cozinha"},
    {"nome": "Entregador", "value": "entregador"}
  ];
  register() async {
    try {
      if (nomeController.text.length < 1 ||
          emailController.text.length < 1 ||
          !emailController.text.contains("@")) {
        snack("informações inválidas", Colors.red);

        return;
      }
      if (user == null && senhaController.text.length < 6) {
        snack("Senha inválida", Colors.red);
        return;
      }
      if (selected!['value'] == "") {
        snack("Selecione uma categoria", Colors.red);
        return;
      }
      var result = await controller.registerFuncionario(nomeController.text,
          emailController.text, senhaController.text, selected!['value'], user);
      if (result) {
        nomeController.text = "";
        emailController.text = "";
        senhaController.text = "";
        if (user != null)
          Navigator.of(context).pop();
        else {
          snack("${selected!['nome']} cadastrado", Colors.green);
          Navigator.of(context).pop();
        }
      } else
        snack("Email pode ja está sendo utilizado", Colors.red);
    } catch (e) {
      print(e);
    }
  }

  snack(text, color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 1500),
      backgroundColor: color,
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (user != null) {
      nomeController.text = user!.nome!;
      emailController.text = user!.email!;
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          selected = categorias
              .where((element) => element['value'] == user!.type)
              .single;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var statusSize = MediaQuery.of(context).padding.top;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: statusSize,
            color: Colors.orange,
          ),
          Container(
            child: Icon(
              Icons.person,
              size: 80,
              color: Colors.white,
            ),
            margin: EdgeInsets.only(top: 30, bottom: 30),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(200))),
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            children: [
              Card(
                elevation: 3,
                margin: EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      child: Text(
                        "Informações De Acesso",
                        style: TextStyle(fontSize: 20),
                      ),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16, bottom: 16),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextField(
                        keyboardType: TextInputType.name,
                        controller: nomeController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black12,
                            labelText: "Nome"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black12,
                            labelText: "Email"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 8),
                      child: TextField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _toggle,
                        controller: senhaController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black12,
                          labelText:
                              user != null ? "Senha (opcional)" : "Senha",
                          suffixIcon: GestureDetector(
                            child: Icon(icon),
                            onTap: () {
                              setState(() {
                                _toggle = !_toggle;
                                icon = _toggle ? Icons.lock : Icons.lock_open;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: DropdownButton(
                          isExpanded: true,
                          onChanged: (dynamic val) {
                            setState(() {
                              selected = val;
                            });
                          },
                          hint: Text(selected!['nome']!),
                          items: List.generate(categorias.length, (index) {
                            return DropdownMenuItem(
                              child: Text(categorias[index]["nome"]!),
                              value: categorias[index],
                            );
                          }),
                        )),
                    LayoutBuilder(
                      builder: (ctx, biggest) {
                        return FlatButton(
                          color: Colors.orange,
                          minWidth: biggest.biggest.width - 32,
                          child: Text(
                            user != null ? "Atualizar" : "Cadastrar",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            register();
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
