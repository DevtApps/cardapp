import 'package:cardapio/api/socket/ConnectionManager.dart';
import 'package:cardapio/api/socket/NotificationManager.dart';
import 'package:cardapio/restaurante/page/entregador/EntregadorModel.dart';
import 'package:cardapio/restaurante/page/entregador/fragment/entregas/EntregasView.dart';
import 'package:cardapio/restaurante/page/entregador/fragment/pedidos/EntregadorPedidosView.dart';
import 'package:cardapio/usuario/model/Delivery.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntregadorView extends StatefulWidget {
  @override
  _EntregadorViewState createState() => _EntregadorViewState();
}

class _EntregadorViewState extends EntregadorModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          nome != null ? nome! : "",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () async {
                await storage.deleteAll();
                try {
                  it<ConnectionManager>().close();
                  await it.unregister<ConnectionManager>();
                  await it.reset();
                } catch (e) {
                  print(e);
                }
                Navigator.of(context).pushReplacementNamed("login");
              })
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [pedidosView!, entregasView!],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: changePage,
        items: [
          BottomNavigationBarItem(
            label: "Pedidos",
            icon: Icon(Icons.shopping_bag_outlined),
          ),
          BottomNavigationBarItem(
            label: "Minhas Entregas",
            icon: Icon(Icons.time_to_leave_outlined),
          )
        ],
      ),
    );
  }
}
