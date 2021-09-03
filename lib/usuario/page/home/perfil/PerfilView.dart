import 'package:cardapio/api/model/DadosPessoais.dart';
import 'package:cardapio/api/socket/ConnectionManager.dart';
import 'package:flutter/material.dart';

import 'PerfilModel.dart';

class PerfilView extends StatefulWidget {
  @override
  _PerfilViewState createState() => _PerfilViewState();
}

class _PerfilViewState extends PerfilModel {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          return await Future.delayed(Duration(seconds: 1), () {
            return;
          });
        },
        child: FutureBuilder(
          builder: (c, snap) {
            if (snap.hasData) {
              DadosPessoais perfil = snap.data as DadosPessoais;
              return ListView(
                padding: EdgeInsets.only(top: 32, right: 16, left: 16),
                children: [
                  Container(
                    width: size.width,
                    height: size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.4,
                              height: size.width * 0.4,
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.person,
                                size: size.width * 0.3,
                                color: Colors.white,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.3),
                                /*image: DecorationImage(
                                  image: perfil.picture == null
                                      ? AssetImage("assets/images/user.png")
                                      : NetworkImage(perfil.picture),
                                ),

                                 */
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            perfil.nome!,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, bottom: 8, top: 8),
                    child: Text(
                      "Pessoal",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  /* Card(
                    child: ListTile(
                      title: Text("Forma de Pagamento"),
                      trailing: Icon(Icons.payment_outlined),
                    ),
                  ),

                  */
                  Card(
                    child: ListTile(
                      title: Text("Alterar Endereço"),
                      trailing: Icon(Icons.location_on_outlined),
                      onTap: () async {
                        await Navigator.of(context).pushNamed("endereco");
                        setState(() {});
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Alterar Senha"),
                      trailing: Icon(Icons.vpn_key_outlined),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      tileColor: Colors.orange,
                      title: Text(
                        "Sair",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        await storage.deleteAll();
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
                  ),
                ],
              );
            } else if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  value: null,
                ),
              );
            } else
              return Center(
                  child: TextButton(
                child: Text("Recarregar"),
                onPressed: () {
                  setState(() {});
                },
              ));
          },
          future: loadPerfil(),
        ),
      ),
    );
  }
}
