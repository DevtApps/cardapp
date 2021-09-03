import 'package:cardapio/api/controller/DeliveryController.dart';
import 'package:cardapio/api/controller/MesaController.dart';
import 'package:cardapio/api/controller/ProdutoController.dart';
import 'package:cardapio/api/controller/UserController.dart';
import 'package:cardapio/api/model/Categoria.dart';

import 'package:cardapio/api/model/Produto.dart';
import 'package:cardapio/api/controller/PaymentController.dart';
import 'package:cardapio/faturamento/card/CardFormView.dart';
import 'package:cardapio/faturamento/delivery/CardForm.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:cardapio/usuario/page/home/perfil/endereco/model/Endereco.dart';
import 'package:cardapio/usuario/page/home/resume/ResumeArgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:intl/intl.dart';

import 'view/DialogPedido.dart';

class ProdutoPageUser extends StatefulWidget {
  var nextPedidos;
  ProdutoPageUser(this.nextPedidos);
  @override
  _ProdutoPageState createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPageUser>
    with TickerProviderStateMixin {
  FocusNode node = FocusNode();

  DeliveryController deliveryController = DeliveryController();
  List<PedidoDelivery> pedidos = [];

  List<Categoria> categorys = [];

  List<Produto?> produtos = [];
  List<Produto> produtosAux = [];
  var filtro = [];
  GlobalKey _scaffold = new GlobalKey<ScaffoldState>();

  UserController userController = UserController();
  var produtoController = ProdutoController();
  double? _progress = 0.0;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.orange,
        statusBarIconBrightness: Brightness.light));

    Future.delayed(Duration(milliseconds: 500), () {
      loadProdutos();
      loadCategorys();
      setState(() {
        _progress = null;
      });
    });

    controller = new AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
        reverseDuration: Duration(milliseconds: 400));
  }

  loadProdutos() async {
    try {
      List<Produto> result = await produtoController.produtos();
      print("$result produto");
      if (result != null) {
        setState(() {
          produtos = result;
          produtosAux = result;
        });
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              "Não encontramos nenhum Produto",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.deepOrange));
      }
    } catch (e) {
      print(e);
    }
    try {
      setState(() {
        _progress = 0.0;
      });
    } catch (e) {}
  }

  refresh() async {
    await loadCategorys();
    await loadProdutos();
    return;
  }

  loadCategorys() async {
    try {
      List<Categoria> result = await produtoController.listCategorys();
      print("$result categria");
      if (result != null) {
        setState(() {
          categorys = result;
        });
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              "Não encontramos nenhuma categoria",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.deepOrange));
      }
    } catch (e) {
      print(e);
    }
    try {
      setState(() {
        _progress = 0.0;
      });
    } catch (e) {}
  }

  filter({list}) {
    if (list != null) {
      if (filtro.length > 0) {
        List<Produto?> aux = [];
        for (var p in list) {
          if (filtro.contains(p.categoria.nome)) {
            aux.add(p);
          }
        }
        produtos = aux;
      } else {
        produtos = list;
      }
    } else {
      if (filtro.length > 0) {
        List<Produto> aux = [];
        for (var p in produtosAux) {
          if (filtro.contains(p.categoria!.nome)) {
            aux.add(p);
          }
        }
        produtos = aux;
      } else {
        produtos = produtosAux;
      }
    }
  }

  search() {
    try {
      var text = searchController.text;

      if (text.length > 0) {
        produtos = produtosAux;
        List<Produto?> aux = [];
        for (var p in produtos) {
          if (p!.nome!.toLowerCase().contains(text.toLowerCase())) {
            aux.add(p);
          }
        }
        setState(() {
          produtos = aux;
          filter(list: produtos);
        });
      } else {
        setState(() {
          produtos = produtosAux;
          filter();
        });
      }
    } catch (e) {}
  }

  var show = false;

  AnimationController? controller;

  @override
  Widget build(BuildContext context) {
    var statusSize = MediaQuery.of(context).padding.top;
    var size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffold,
        body: Stack(
          children: [
            RefreshIndicator(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      color: Colors.orange[400],
                      height: statusSize,
                      width: double.infinity,
                    ),
                    Container(
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 3),
                              spreadRadius: -5,
                              blurRadius: 3)
                        ]),
                        //height: size.height * 0.19,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.orange,
                              child: TextField(
                                controller: searchController,
                                onChanged: (text) {
                                  search();
                                },
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        search();
                                      },
                                    ),
                                    hintText: "Procurar...",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none),
                                focusNode: node,
                              ),
                            ),
                            Container(
                              height: size.height * 0.1,
                              child: StaggeredGridView.countBuilder(
                                padding: EdgeInsets.all(4),
                                scrollDirection: Axis.horizontal,
                                crossAxisCount: 4,
                                itemCount: categorys.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        category(categorys[index], index),
                                staggeredTileBuilder: (int index) =>
                                    new StaggeredTile.count(
                                        2,
                                        categorys[index]
                                                    .nome
                                                    .toString()
                                                    .length >
                                                6
                                            ? 5
                                            : 4),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: produtos.length,
                        itemBuilder: (ctx, i) {
                          return Item(produtos[i], ctx);
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                      ),
                    )
                  ],
                ),
                onRefresh: () => refresh()),
            Center(
              child: CircularProgressIndicator(
                value: _progress,
              ),
            )
          ],
        ),
        floatingActionButton: pedidos.length > 0
            ? FloatingActionButton.extended(
                label: Text(
                  show ? "Fechar" : "Revisar",
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  show ? Icons.close : Icons.done,
                  color: Colors.white,
                ),
                onPressed: () {
                  //Navigator.pop(context);
                  node.unfocus();
                  setState(() {
                    show = !show;
                  });
                },
              )
            : SizedBox(),
        bottomSheet: show
            ? BottomSheet(
                builder: (c) {
                  return Bottom(size);
                },
                animationController: controller,
                onClosing: () {},
              )
            : SizedBox());
  }

  Widget category(item, index) {
    return GestureDetector(
      child: AnimatedContainer(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: 5, spreadRadius: -4)
              ],
              color: item.active ? Colors.orange : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(100))),
          alignment: Alignment.center,
          padding: EdgeInsets.all(0),
          curve: Curves.ease,
          duration: Duration(milliseconds: 450),
          child: LayoutBuilder(
            builder: (ctx, biggest) {
              var size = biggest.biggest;
              return Text(
                item.nome,
                style: TextStyle(
                    color: item.active ? Colors.white : Colors.black,
                    fontSize: size.height * 0.5),
              );
            },
          )),
      onTap: () {
        node.unfocus();
        setState(() {
          categorys[index].active = !categorys[index].active;
          if (categorys[index].active)
            filtro.add(categorys[index].nome);
          else
            filtro.remove(categorys[index].nome);
          search();
        });
      },
    );
  }

  NumberFormat format =
      NumberFormat.currency(locale: "pt_BR", symbol: "R\$", decimalDigits: 2);

  Widget Item(item, ctx) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: 300,
        child: TweenAnimationBuilder<double>(
          builder: (BuildContext context, double value, Widget? child) {
            return Opacity(
              opacity: value,
              child: GestureDetector(
                  child: Card(
                    child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: 1,
                        child: Container(
                          height: size.width * 0.7,
                          child: Column(
                            children: [
                              Image(
                                image: NetworkImage(
                                  item.image,
                                ),
                                height: size.width * 0.3,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                item.nome,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                              Text(
                                format.format(item.preco),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        )),
                  ),
                  onTap: () async {
                    node.unfocus();
                    var pedido = await Navigator.push(
                        context,
                        PageRouteBuilder(
                            opaque: false,
                            fullscreenDialog: true,
                            pageBuilder: (ctx, a1, a2) => DialogPedido(item)));

                    if (pedido != null) {
                      setState(() {
                        pedidos.add(pedido);
                      });
                    }
                  }),
            );
          },
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
        ));
  }

  Widget Bottom(size) {
    return Card(
      child: Container(
          height: size.height * 0.6,
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: pedidos.length,
                  itemBuilder: (ctx, i) {
                    PedidoDelivery pedido = pedidos[i];
                    return ListTile(
                        title: Text(pedido.produto!.nome!),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
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
                                                margin: EdgeInsets.all(16),
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
                                                          child: FlatButton(
                                                            child:
                                                                Text("EDITAR"),
                                                            onPressed: () {},
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: FlatButton(
                                                            child: Text("OK"),
                                                            onPressed: () {
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
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.orange,
                              ),
                              onPressed: () async {
                                /*
                                try {
                                  var pedido = await Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          opaque: false,
                                          fullscreenDialog: true,
                                          pageBuilder: (ctx, a1, a2) =>
                                              DialogPedido(
                                                  pedidos[i].produto, mesa,
                                                  pedido: pedidos[i],
                                                  pedindo: true)));
                                  if (pedido != false) {
                                    setState(() {
                                      pedidos.insert(i, pedido);
                                      pedidos.removeAt(i + 1);
                                    });
                                  }
                                } catch (e) {}
                                */
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.orange,
                              ),
                              onPressed: () async {
                                setState(() {
                                  pedidos.removeAt(i);
                                  if (pedidos.length == 0) show = false;
                                });
                              },
                            ),
                            pedido.status == 1
                                ? Icon(
                                    Icons.access_time_sharp,
                                    color: Colors.orange,
                                  )
                                : SizedBox(),
                          ],
                        ));
                  },
                ),
              ),
              Container(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text("Finalizar"),
                    textColor: Colors.white,
                    color: Colors.orange,
                    onPressed: () async {
                      setState(() {
                        show = !show;
                      });
                      await Navigator.of(context)
                          .pushNamed("resume", arguments: ResumeArgs(pedidos));
                      widget.nextPedidos();
                    },
                  ))
            ],
          )),
    );
  }

  showFinishDelivery(size) {
    showBottomSheet(
        context: context,
        builder: (c) {
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
                                  onTap: () async {},
                                ),
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
                      future: userController.getEnderecos(),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
