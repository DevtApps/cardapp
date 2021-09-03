import 'package:cardapio/api/controller/UserController.dart';
import 'package:cardapio/usuario/page/home/perfil/endereco/model/Endereco.dart';
import 'package:flutter/material.dart';

class ChoiceAddres extends StatefulWidget {
  @override
  _ChoiceAddresState createState() => _ChoiceAddresState();
}

class _ChoiceAddresState extends State<ChoiceAddres> {
  UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: Container(
        height: size.height / 2,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Text("Escolha o endereço de entrega",
                  style: TextStyle(fontSize: 16)),
            ),
            Expanded(
              child: FutureBuilder(
                builder: (context, snap) {
                  if (snap.hasData) {
                    List<Endereco> list = snap.data as List<Endereco>;
                    return ListView.builder(
                      itemBuilder: (c, i) {
                        return Card(
                          child: ListTile(
                            title: Text(list[i].nome),
                            subtitle: Text(list[i].formatted),
                            onTap: () {
                              Navigator.of(context).pop(list[i]);
                            },
                          ),
                        );
                      },
                      itemCount: list.length,
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
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text("Tentar novamente"),
                      ),
                    );
                },
                future: userController.getEnderecos(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
