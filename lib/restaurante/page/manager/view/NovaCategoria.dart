import 'package:cardapio/api/controller/ProdutoController.dart';
import 'package:cardapio/api/model/Categoria.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NovaCategoria extends StatefulWidget {
  @override
  _NovaCategoriaState createState() => _NovaCategoriaState();
}

class _NovaCategoriaState extends State<NovaCategoria> {
  var categoryController = TextEditingController();
  var produtoController = ProdutoController();
  double? _progress = 0.0;
  bool? _preparar = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: Card(
                margin: EdgeInsets.all(28),
                child: Container(
                  padding: EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Nova Categoria",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        textCapitalization: TextCapitalization.words,
                        controller: categoryController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: "categoria",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                      CheckboxListTile(
                        title: Text("Preparação"),
                        value: _preparar,
                        onChanged: (value) {
                          setState(() {
                            _preparar = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            color: Colors.orange,
                            child: Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FlatButton(
                            color: Colors.orange,
                            child: Text("Criar",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              if (categoryController.text.length > 0) {
                                setState(() {
                                  _progress = null;
                                });
                                var result = await produtoController
                                    .createCategory(Categoria(
                                        nome: categoryController.text,
                                        preparar: _preparar));
                                if (result) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        "Categoria criada",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green));
                                  setState(() {
                                    _progress = null;
                                    Navigator.of(context).pop(true);
                                  });
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                        "Não foi possível concluir",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red));
                                  setState(() {
                                    _progress = null;
                                    Navigator.of(context).pop(false);
                                  });
                                }
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),
        Center(
            child: CircularProgressIndicator(
          value: _progress,
        ))
      ],
    );
  }
}
