import 'package:cardapio/api/controller/UserController.dart';
import 'package:cardapio/api/model/User.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CadastrarUsuario.dart';

class GerenciarUsuario extends StatefulWidget {
  @override
  _GerenciarUsuarioState createState() => _GerenciarUsuarioState();
}

class _GerenciarUsuarioState extends State<GerenciarUsuario> {
  UserController controller = UserController();
  List<User> users = [];

  loadUsuarios() async {
    try {
      List<User> result = await controller.users();
      if (result == null) {
        snack("Nenhum usuário encontrado", Colors.orange);
        setState(() {
          users = [];
        });
      } else {
        setState(() {
          users = result;
        });
      }
    } catch (e) {
      snack("Falha na conexão", Colors.red);
    }
    return;
  }

  delete(id) async {
    try {
      bool result = await controller.delete(id);
      if (result == null) {
        snack("Usuário não encontrado", Colors.orange);
      } else {
        snack("Usuário deletado", Colors.green);
      }
    } catch (e) {
      snack("Falha na conexão", Colors.red);
    }
    return;
  }

  snack(text, color) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1000),
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      loadUsuarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Usuários",
          style: TextStyle(color: Colors.white),
        ),
        brightness: Brightness.dark,
        leading: SizedBox(),
        leadingWidth: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        label: Text(
          "Novo",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (c) => CadastrarUsuario()));
          loadUsuarios();
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => loadUsuarios(),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (ctx, i) {
            User user = users[i];

            return ListTile(
              title: Text(user.nome!),
              trailing: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => CadastrarUsuario(user: user)));
                      loadUsuarios();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.orange,
                    ),
                    onPressed: () async {
                      await delete(user.sId);
                      loadUsuarios();
                    },
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
            );
          },
        ),
      ),
    );
  }
}
