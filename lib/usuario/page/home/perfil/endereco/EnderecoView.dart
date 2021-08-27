import 'package:cardapio/api/controller/UserController.dart';
import 'package:cardapio/api/model/DadosPessoais.dart';
import 'package:cardapio/usuario/page/home/perfil/endereco/model/Endereco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class EnderecoView extends StatefulWidget {
  @override
  _EnderecoViewState createState() => _EnderecoViewState();
}

class _EnderecoViewState extends State<EnderecoView> {
  TextEditingController nameController = TextEditingController();
  MaskedTextController cpfController =
  MaskedTextController(mask: "000.000.000-00");
  UserController userController = UserController();
  loadData() async {
    try {
      var result = await userController.getEnderecos();

      if (result != null) {
        return result;
      } else
        return  List<Endereco>();
    } catch (e) {
      return List<Endereco>();
    }
  }

  loadPerfil()async{
    try {
      DadosPessoais result = await userController.getPerfil();

      if (result != null) {
        nameController.text = result.nome;
        cpfController.text = result.cpf != null? result.cpf:"";
      } else
        return null;
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPerfil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        title: Text(
          "Dados e Endereço",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    maxLines: 1,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "Nome Completo",
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: cpfController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    maxLines: 1,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: "CPF (opcional)",
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.all(12),
                        child: Text(
                          "Endereços",
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.all(12),
                          child: Text(
                            "Novo Endereço",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                        onTap: () async {
                          await Navigator.of(context).pushNamed("locator");
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: FutureBuilder(
                      builder: (context, snap) {


                        if (snap.hasData) {
                          List<Endereco> list = snap.data;
                          if(list.isEmpty){
                            return Center(child: Text("Cadastre um endereço"),);
                          }
                          return ListView.builder(
                            itemBuilder: (c, i) {
                              return ListTile(
                                  title: Text(list[i].nome),
                                  subtitle: Text(list[i].formatted),
                                trailing: IconButton(icon: Icon(Icons.delete, color: Colors.red,), onPressed: ()async{
                                  var result = await userController.deleteAddres(list[i].id);
                                  if(!result){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Não foi possível deletar o endereço")));
                                  }else setState(() {

                                  });
                                },),
                                  );
                            },
                            itemCount: list.length,
                          );
                        } else if (snap.connectionState ==
                            ConnectionState.waiting) {
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
                      future: loadData(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                child: Text("Salvar"),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
