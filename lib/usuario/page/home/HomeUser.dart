import 'package:cardapio/usuario/page/home/perfil/PerfilView.dart';
import 'package:flutter/material.dart';

import 'main/MainView.dart';
import 'pedidos/PedidosDelivery.dart';
import 'produtos/ProdutoPageUser.dart';

class HomeUser extends StatefulWidget {
  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  var currentSelected = 0;

  PageController _pageController = PageController(initialPage: 0);
  MainView? produtoPageUser;
  PedidosDelivery pedidosDelivery = PedidosDelivery();
  PerfilView perfilView = PerfilView();

  @override
  void initState() {
    super.initState();
    produtoPageUser = MainView(nextPedidos);
  }

  nextPedidos() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 600), curve: Curves.ease);
    setState(() {
      currentSelected = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          produtoPageUser!,
          pedidosDelivery,
          perfilView,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentSelected,
        onTap: (i) {
          setState(() {
            currentSelected = i;
          });
          _pageController.animateToPage(i,
              duration: Duration(milliseconds: 800), curve: Curves.ease);
        },
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: "pedidos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined), label: "perfil"),
        ],
      ),
    );
  }
}
