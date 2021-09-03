import 'package:cardapio/api/controller/DeliveryController.dart';
import 'package:cardapio/usuario/model/Delivery.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'EntregadorView.dart';
import 'fragment/entregas/EntregasView.dart';
import 'fragment/pedidos/EntregadorPedidosView.dart';

abstract class EntregadorModel extends State<EntregadorView> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  GetIt it = GetIt.instance;
  DeliveryController deliveryController = DeliveryController();
  NumberFormat currency = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
  EntregadorPedidosView? pedidosView;
  EntregasView? entregasView;
  PageController? controller;
  var currentPage = 0;

  String? nome = "";

  changePage(int index) {
    controller!.animateToPage(index,
        duration: Duration(milliseconds: 400), curve: Curves.ease);
    setState(() {
      currentPage = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: currentPage);
    pedidosView = EntregadorPedidosView(changePage);
    entregasView = EntregasView();

    init();
  }

  init() async {
    var name = await storage.read(key: "nome");
    setState(() {
      nome = name;
    });
  }
}
