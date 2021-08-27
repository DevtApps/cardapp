import 'package:cardapio/api/controller/ProdutoController.dart';
import 'package:cardapio/api/model/Categoria.dart';
import 'package:cardapio/api/model/Produto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'NovoProduto.dart';

class TodosProdutos extends StatefulWidget {
  @override
  _TodosProdutosState createState() => _TodosProdutosState();
}

class _TodosProdutosState extends State<TodosProdutos>
    with SingleTickerProviderStateMixin {
  List<Categoria> categorys = [];

  List<Produto> produtos = [];
  List<Produto> produtosAux = [];
  var filtro = [];

  var produtoController = ProdutoController();
  var _progress = 0.0;

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
    setState(() {
      _progress = 0.0;
    });
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
        List<Produto> aux = [];
        for (var p in list) {
          if (filtro.contains(p.categoria)) {
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
          if (filtro.contains(p.categoria)) {
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
    var text = searchController.text;

    if (text.length > 0) {
      produtos = produtosAux;
      List<Produto> aux = [];
      for (var p in produtos) {
        if (p.nome.toLowerCase().contains(text.toLowerCase())) {
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
  }

  @override
  Widget build(BuildContext context) {
    var statusSize = MediaQuery.of(context).padding.top;
    var size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
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
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                          ),
                        ),
                        /*Container(
                            height: size.height * 0.1,
                            child: StaggeredGridView.countBuilder(
                              padding: EdgeInsets.all(4),
                              scrollDirection: Axis.horizontal,
                              crossAxisCount: 4,
                              itemCount: categorys.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  category(categorys[index], index),
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.count(
                                      2,
                                      categorys[index].nome.toString().length >
                                              6
                                          ? 5
                                          : 4),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            ),
                          ),*/
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: produtos.length,
                      itemBuilder: (ctx, i) {
                        return Item(produtos[i]);
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
    );
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

  Widget Item(item) {
    return TweenAnimationBuilder<double>(
      builder: (BuildContext context, double value, Widget child) {
        return Opacity(
            opacity: value,
            child: GestureDetector(
                child: Stack(
                  children: [
                    Card(
                        child: AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: 1,
                      child: LayoutBuilder(
                        builder: (ctx, layout) {
                          var size = layout.biggest;
                          return Column(
                            children: [
                              Image(
                                image: NetworkImage(
                                  item.image,
                                ),
                                width: double.infinity,
                                height: size.width * 0.6,
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    item.nome,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontSize: size.height * 0.11),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )),
                    LayoutBuilder(
                      builder: (ctx, bigg) {
                        var size = bigg.biggest;
                        return Container(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: size.width * 0.35,
                              height: size.width * 0.35,
                              margin: EdgeInsets.all(4),
                              color: Colors.black.withOpacity(0.5),
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: size.width * 0.18),
                            ));
                      },
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => NovoProduto(produto: item)));
                }));
      },
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 700),
      curve: Curves.fastOutSlowIn,
    );
  }
}
