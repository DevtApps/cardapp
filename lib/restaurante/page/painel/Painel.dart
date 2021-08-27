import 'package:cardapio/api/socket/ConnectionManager.dart';
import 'package:cardapio/api/socket/NotificationManager.dart';
import 'package:cardapio/faturamento/page/Pagamento.dart';
import 'package:cardapio/restaurante/page/home/Home.dart';
import 'package:cardapio/restaurante/page/manager/GerenciarUsuario.dart';
import 'package:cardapio/restaurante/page/manager/NovoProduto.dart';
import 'package:cardapio/restaurante/page/manager/Sobre.dart';
import 'package:cardapio/restaurante/page/manager/TodosProdutos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'ModelPainel.dart';

class Painel extends StatefulWidget {
  _PainelState _painelState = _PainelState();
  GetIt it = GetIt.instance;

  @override
  _PainelState createState() => _painelState;
}

class _PainelState extends State<Painel> {
  ModelPainel model;
  FlutterSecureStorage secure;
  GetIt it = GetIt.instance;

  @override
  void initState() {
    super.initState();
    secure = FlutterSecureStorage();
    init();
  }

  init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Painel",
          style: TextStyle(color: Colors.white),
        ),
        leadingWidth: 0,
        leading: SizedBox(),
        brightness: Brightness.dark,
        actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => Sobre()));
            },
          )
        ],
      ),
      body: GridView.count(
        padding: EdgeInsets.all(8),
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        crossAxisCount: 2,
        children: [
          FlatButton(
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.restaurant,
                  size: 100,
                  color: Colors.white,
                ),
                Text(
                  "Restaurante",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
            onPressed: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => Home()));
              setState(() {});
            },
          ),
          FlatButton(
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.code_sharp,
                  size: 100,
                  color: Colors.white,
                ),
                Text(
                  "Cozinha",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
            onPressed: () async {
              await Navigator.of(context).pushNamed("cozinha");
              setState(() {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
              });
            },
          ),
          FlatButton(
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.graphic_eq,
                  size: 100,
                  color: Colors.white,
                ),
                Text(
                  "Relatório",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
            onPressed: () async {
              await Navigator.of(context).pushNamed("relatorio");
              setState(() {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
              });
            },
          ),
          FlatButton(
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.my_library_add,
                  size: 100,
                  color: Colors.white,
                ),
                Text(
                  "Adicionar Produto",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => NovoProduto()));
            },
          ),
          FlatButton(
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.storage,
                  size: 100,
                  color: Colors.white,
                ),
                Text(
                  "Produtos",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => TodosProdutos()));
            },
          ),
          FlatButton(
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.group,
                  size: 100,
                  color: Colors.white,
                ),
                Text(
                  "Gerenciar Usuarios",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => GerenciarUsuario()));
            },
          ),
          FlatButton(
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.credit_card,
                  size: 100,
                  color: Colors.white,
                ),
                Text(
                  "Pagamentos",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => Pagamento()));
            },
          ),
          FlatButton(
            color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.exit_to_app_sharp,
                  size: 100,
                  color: Colors.white,
                ),
                Text(
                  "Sair",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
            onPressed: () async {
              await secure.deleteAll();
              try {
                it<ConnectionManager>().close();
                await it.unregister<ConnectionManager>();
                await it.reset();
              } catch (e) {
                print(e);
              }
              Navigator.of(context).pushReplacementNamed("login");
            },
          ),
        ],
      ),
    );
  }
}
