import 'dart:convert';

import 'package:cardapio/api/controller/FaturamentoController.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shimmer/shimmer.dart';

class Pagamento extends StatefulWidget {
  @override
  _PagamentoState createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {
  var loading = true;

  FaturamentoController controller = FaturamentoController();

  var nome = "";
  var link = "";
  var teste = 0;
  var dias = 0;

  @override
  initState() {
    super.initState();
    init();
  }

  init() async {
    try {
      loading = true;
      reload();
      Response response = await controller.getFaturamento();
      if (response != null) {
        var json = jsonDecode(response.body);

        if (response.statusCode == 200) {
          teste = json['teste'];
          dias = json['dias'];

          nome = json['nome'];
          reload();
        } else if (response.statusCode == 201) {
          nome = json['nome'];
          link = json['link'];

          reload();
        } else if (response.statusCode == 202) {
          nome = json['nome'];
          reload();
        } else {
          print("erro");
        }
      }
      loading = false;
      reload();
    } catch (e) {
      loading = false;
      reload();
      print("erro");
    }
  }

  reload() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    return Scaffold(
      body: Column(
        children: [
          Container(
            //height: size.height * 0.26,
            child: Card(
              elevation: 4,
              color: Colors.orange,
              margin: EdgeInsets.zero,
              child: Container(
                padding: EdgeInsets.only(
                    top: padding.top * 1.5, bottom: padding.top / 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: nome.length == 0 || loading
                          ? Shimmer.fromColors(
                              baseColor: Colors.white12,
                              highlightColor: Colors.white70,
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    color: Colors.white,
                                    height: 15,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 70,
                                    color: Colors.grey,
                                    height: 15,
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              nome,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: size.width * 0.06),
                            ),
                    ),
                    Center(
                        child: nome.length == 0 || loading
                            ? Shimmer.fromColors(
                                baseColor: Colors.white12,
                                highlightColor: Colors.white70,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 170,
                                      color: Colors.white,
                                      height: 30,
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                teste == 0
                                    ? "R\$149,99"
                                    : "Restam $dias dias Grátis",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: teste == 0
                                        ? size.width * 0.12
                                        : size.width * 0.08,
                                    color: Colors.white))),
                    Center(
                      child: nome.length == 0 || loading
                          ? Shimmer.fromColors(
                              baseColor: Colors.white12,
                              highlightColor: Colors.white70,
                              child: Column(
                                children: [
                                  Container(
                                    width: 100,
                                    color: Colors.white,
                                    height: 12,
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              "Plano Básico",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: size.width * 0.04),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: loading
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Buscando Informações",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator(value: null)
                    ],
                  ))
                : nome.length == 0
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ops, Não conseguimos encontrar suas informações!",
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Icon(Icons.error, color: Colors.red, size: 60),
                          SizedBox(
                            height: 50,
                          ),
                          FlatButton(
                            child: Text("Recarregar"),
                            color: Colors.orange,
                            textColor: Colors.white,
                            onPressed: () {
                              init();
                            },
                          )
                        ],
                      ))
                    : RefreshIndicator(
                        onRefresh: () {
                          return init();
                        },
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          children: [
                            ListTile(
                                title: Text("Débitos"),
                                tileColor: link.length > 0
                                    ? Colors.yellow
                                    : Colors.transparent,
                                trailing: link.length > 0
                                    ? FlatButton(
                                        child: Text("Pagar"),
                                        onPressed: () async {
                                          /* AndroidIntent intent = AndroidIntent(
                                            action: "action_view",
                                            data: Uri.encodeFull(link),
                                            flags: <int>[
                                              Flag.FLAG_ACTIVITY_NEW_TASK
                                            ],
                                          );
                                          await intent.launch();
                                          */
                                        },
                                      )
                                    : Text(
                                        "Em dia",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 16),
                                      )),
                            ListTile(
                                title: Text("Alterar Plano"),
                                trailing: Text(
                                  "Indisponível",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                )),
                            Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Column(
                                children: [
                                  Center(
                                      child: Text(
                                    "Vantagens do seu plano",
                                    style: TextStyle(fontSize: 20),
                                  )),
                                  ListTile(
                                    title: Text("Produtos ilimitados"),
                                    trailing: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Mesas ilimitadas"),
                                    trailing: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Funcionários ilimitados"),
                                    trailing: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Atualização em tempo real"),
                                    trailing: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Autoatendimento"),
                                    trailing: Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Divisão da conta"),
                                    trailing: Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Compartilhamento de produtos"),
                                    trailing: Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Delivery"),
                                    trailing: Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Image.asset("image/icon_whatsapp.png", width: size.width * 0.1),
        onPressed: () async {
          /*
          AndroidIntent intent = AndroidIntent(
            action: "action_view",
            data: Uri.encodeFull(
                "https://api.whatsapp.com/send?phone=5519998591751"),
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          await intent.launch();
          */
        },
        label: Text(
          "Suporte",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
