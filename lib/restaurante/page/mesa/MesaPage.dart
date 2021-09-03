import 'package:cardapio/api/controller/MesaController.dart';

import 'package:cardapio/api/model/Mesa.dart';
import 'package:cardapio/api/model/Pedido.dart';
import 'package:cardapio/restaurante/page/cozinha/home/ModelCozinha.dart';

import 'package:cardapio/restaurante/page/produtos/ProdutoPage.dart';
import 'package:cardapio/restaurante/page/produtos/view/DialogPedido.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'FecharMesa.dart';

class MesaPage extends StatefulWidget {
  var mesa;

  MesaPage(this.mesa);
  @override
  _MesaPageState createState() => _MesaPageState(mesa);
}

class _MesaPageState extends State<MesaPage> {
  ModelCozinha modelCozinha = ModelCozinha();
  GetIt it = GetIt.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.orange,
        statusBarIconBrightness: Brightness.light));
    modelCozinha.pedido = update;
    it.registerSingleton(modelCozinha);
    Future.delayed(Duration(milliseconds: 300), () => loadMesa());
  }

  update() {
    loadMesa();
  }

  reload(){
    if(mounted)setState(() {
      
    });
  }

  Mesa mesa;
  List<Pedido> pedidos = [];
  _MesaPageState(this.mesa);
  dynamic _progress = null;
  var total = 0.0;
  var valor = "R\$0,00";

  var deletando = false;
  var atualizando = false;

  MesaController mesaController = MesaController();
  NumberFormat format =
      NumberFormat.currency(decimalDigits: 2, locale: "pt_BR", symbol: "R\$");

  @override
  deactivate() {
    super.deactivate();
    it.unregister(instance: modelCozinha);
  }

  loadMesa() async {
    try {
      setState(() {
        _progress = null;
      });
      var mesaDetalhe = await mesaController.mesa(mesa.id);

      if (mesaDetalhe != null) {
        setState(() {
          total = 0;
          pedidos = [];
          for (var pedido in mesaDetalhe.itens) {
            Pedido p = Pedido.fromJson(pedido);
            pedidos.add(p);
            total += p.produto!.preco! * p.quantidade!;
          }
          valor = format.format(total);
        });
      }
    } catch (e) {
      print("$e mesa");
    }
    try {
      setState(() {
        _progress = 0.0;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Valor ${valor}",
            style: TextStyle(color: Colors.white, fontSize: size.width * 0.05),
          ),
          centerTitle: true,
          brightness: Brightness.dark,
          leadingWidth: size.width * 0.25,
          leading: Center(
            child: Text(
              "Mesa ${mesa.numero}",
              style:
                  TextStyle(color: Colors.white, fontSize: size.width * 0.05),
            ),
          ),
          actions: [
            pedidos.length > 0
                ? IconButton(
                    icon: Icon(Icons.file_download_done),
                    color: Colors.white,
                    onPressed: () async {
                      await showGeneralDialog(
                          context: context,
                          pageBuilder: (ctx, a, s) {
                            return FecharMesa(ctx, mesa);
                          });
                      loadMesa();
                    },
                  )
                : SizedBox()
          ],
        ),
        body: Stack(
          children: [
            _progress == null
                ? Center(
                    child: CircularProgressIndicator(
                    value: _progress,
                  ))
                : (pedidos.length == 0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 200,
                            child: Image.asset("image/emoji_triste.png"),
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Text(
                              "Esta mesa ainda esta vazia\n que tal adicionar alguns pedidos?",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Card(
                              child: FlatButton(
                            //color: Colors.orange,

                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 12, bottom: 12, left: 30, right: 30),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "image/emoji_fome.png",
                                      width: 40,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "ADICIONAR",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.orange[700]),
                                  )
                                ],
                              ),
                            ),

                            onPressed: () async {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (ctx) => ProdutoPage(mesa)));
                              loadMesa();
                            },
                          )),
                        ],
                      )
                    : new RefreshIndicator(
                        child: new ListView.separated(
                          itemBuilder: (ctx, i) {
                            Pedido pedido = pedidos[i];
                            return ListTile(
                                title: Text(pedido.produto!.nome!),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        "${pedido.quantidade}",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    pedido.observacao!.length > 0
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.message,
                                              color: Colors.orange,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return Dialog(
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(16),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              pedido.observacao!,
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      FlatButton(
                                                                    child: Text(
                                                                        "EDITAR"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      showEdit(
                                                                          pedido);
                                                                    },
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      FlatButton(
                                                                    child: Text(
                                                                        "OK"),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                          )
                                        : SizedBox(),
                                    pedido.status == 0
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.orange,
                                            ),
                                            onPressed: () {
                                              showEdit(pedido);
                                            },
                                          )
                                        : SizedBox(),
                                    pedido.status == 0
                                        ? IconButton(
                                            icon:  Icon(
                                              Icons.delete,
                                              color: Colors.orange,
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                _progress = null;
                                              });
                                              await mesaController.deletePedido(
                                                  mesa.id, pedido.sId);
                                              loadMesa();
                                            },
                                          )
                                        : SizedBox(),
                                    pedido.status == 1
                                        ? Icon(
                                            Icons.access_time_sharp,
                                            color: Colors.orange,
                                          )
                                        : SizedBox(),
                                    pedido.status == 2
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.file_download_done,
                                              color: Colors.orange,
                                            ),
                                            onPressed: () async {
                                              
                                              await mesaController.status(
                                                  pedido.status! + 1,
                                                  mesa.id,
                                                  pedido.sId,
                                                  notify: false);
                                                  atualizando = false;
                                                  

                                              loadMesa();
                                            },
                                          )
                                        : SizedBox()
                                  ],
                                ));
                          },
                          itemCount: pedidos.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              color: Colors.black45,
                            );
                          },
                        ),
                        onRefresh: () => loadMesa(),
                      ))
          ],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: pedidos.length > 0
            ? FloatingActionButton(
                child: Icon(Icons.edit, color: Colors.white),
                onPressed: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => ProdutoPage(mesa)));
                  loadMesa();
                },
              )
            : SizedBox());
  }

  showEdit(pedido) async {
    var up = await Navigator.push(
        context,
        PageRouteBuilder(
            opaque: false,
            fullscreenDialog: true,
            pageBuilder: (ctx, a1, a2) => DialogPedido(
                  pedido.produto,
                  mesa,
                  pedido: pedido,
                )));
    if (up != false) loadMesa();
  }
}
