import 'package:cardapio/api/Api.dart';
import 'package:cardapio/api/controller/DeliveryController.dart';
import 'package:cardapio/api/controller/MesaController.dart';
import 'package:cardapio/api/model/Pedido.dart';
import 'package:cardapio/api/socket/ConnectionManager.dart';
import 'package:cardapio/api/socket/NotificationManager.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'ModelCozinha.dart';

class PedidosPage extends StatefulWidget {
  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  MesaController controller = MesaController();
  DeliveryController deliveryController = DeliveryController();
  List<dynamic> pedidos = [];

  var status = [Icons.alarm_add_outlined, Icons.file_download_done];

  GetIt it = GetIt.instance;
  ModelCozinha modelCozinha = ModelCozinha();

  FlutterSecureStorage secure = FlutterSecureStorage();

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    if (it.isRegistered(instance: modelCozinha)) {
      it.unregister(
          instance: modelCozinha,
          disposingFunction: (t) => {print("unregistered")});
    }
  }

  @override
  void initState() {
    super.initState();
    modelCozinha.pedido = loadPedidos;
    it.registerSingleton(modelCozinha);
    Future.delayed(Duration(milliseconds: 100), () {
      loadPedidos();
      init();
    });
  }

  var type = "";
  init() async {
    try {
      var t = await secure.read(key: "type");
      setState(() {
        type = t;
      });
    } catch (e) {}
  }

  pedido(data) {
    loadPedidos();
  }

  loadPedidos() async {
    try {
      List<dynamic> result = await controller.loadPedidos();
      if (result != null) {
        setState(() {
          pedidos = result;
        });
      } else {
        setState(() {
          pedidos = [];
        });
        snack("Nenhum pedido", Colors.orange);
      }
    } catch (e) {
      snack("Erro de conexão", Colors.red);
    }
  }

  snack(text, color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: SizedBox(),
        leadingWidth: 0,
        title: Text(
          "Cozinha",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          type == "cozinha"
              ? IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
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
                )
              : SizedBox()
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => loadPedidos(),
        child: ListView.builder(
          itemBuilder: (ctx, i) {
            var pedido = pedidos[i];
            return Card(
              child: Container(
                margin: EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        child: Text(
                          "${pedido.produto.nome}",
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Text(
                          "${pedido.observacao}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("${pedido.quantidade}"),
                    SizedBox(
                      width: 10,
                    ),
                    if (pedido is PedidoDelivery)
                      Icon(Icons.time_to_leave_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: Icon(status[pedido.status]),
                      onPressed: () async {
                        var result;
                        if (pedido is PedidoDelivery) {
                          result = await deliveryController.statusPedido(
                              pedido.status + 1, pedido);
                        } else
                          result = await controller.status(
                              pedido.status + 1, pedido.mesa, pedido.sId);
                        if (result)
                          loadPedidos();
                        else
                          snack("Não foi possível atualizar pedido",
                              Colors.orange);
                      },
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: pedidos.length,
        ),
      ),
    );
  }
}
