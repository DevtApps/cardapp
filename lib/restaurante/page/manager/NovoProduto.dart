import 'dart:async';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cardapio/api/Api.dart';
import 'package:cardapio/api/controller/ProdutoController.dart';
import 'package:cardapio/api/model/Categoria.dart';
import 'package:cardapio/api/model/Produto.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'view/NovaCategoria.dart';

class NovoProduto extends StatefulWidget {
  Produto? produto;

  NovoProduto({this.produto});
  @override
  _NovoProdutoState createState() => _NovoProdutoState(produto: produto);
}

class _NovoProdutoState extends State<NovoProduto> {
  int? value = 0;
  Produto? produto;

  _NovoProdutoState({this.produto});

  double? _progress = 0.0;
  List<Categoria> categorys = [Categoria(nome: "Categoria")];

  final picker = ImagePicker();

  FlutterSecureStorage secure = FlutterSecureStorage();

  var nomeCon = TextEditingController();
  var descCon = TextEditingController();

  MaskedTextController precoCon = MaskedTextController(mask: "R\$0,00");

  var categoryController = TextEditingController();

  File? image = null;
  var produtoController = ProdutoController();

  save() async {
    if (nomeCon.text.length < 3 ||
        precoCon.text.length < 6 ||
        image!.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 1500),
        backgroundColor: Colors.red,
        content: Text(
          "Complete os campos!",
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else if (categorys[value!].nome == "Categoria") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 1500),
        backgroundColor: Colors.red,
        content: Text(
          "Escolha uma categoria",
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      setState(() {
        _progress = null;
      });
      try {
        var text = precoCon.text.substring(2).replaceFirst(",", ".");
        double.parse(text);
        var url = await upload();
        print(url);
        var result = await produtoController.save(
            nomeCon.text, descCon.text, text, categorys[value!], url, produto);
        print(result);
        if (result) {
          setState(() {
            _progress = 0.0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                duration: Duration(milliseconds: 1500),
                backgroundColor: Colors.green,
                content: Text(
                  "Produto cadastrado",
                  style: TextStyle(color: Colors.white),
                )),
          );
          nomeCon.text = "";
          descCon.text = "";
          precoCon.text = "";
        } else {
          setState(() {
            _progress = 0.0;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 1500),
            backgroundColor: Colors.red,
            content: Text(
              "Não foi possível cadastrar o produto",
              style: TextStyle(color: Colors.white),
            ),
          ));
        }
      } catch (e) {
        print(e);
        setState(() {
          _progress = 0.0;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.red,
          content: Text(
            "Não foi possível cadastrar o produto",
            style: TextStyle(color: Colors.white),
          ),
        ));
      }
    }
  }

  getImage() async {
    try {
      var pickedFile = await (picker.getImage(source: ImageSource.gallery) as FutureOr<PickedFile>);
      if (pickedFile.path != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  upload() async {
    var token = await secure.read(key: "token");
    FirebaseStorage storage = FirebaseStorage.instance;
    var data = DateTime.now();
    var ref = storage.ref().child(APP).child("produtos").child(
        "${image!.path.substring(image!.path.lastIndexOf("/"))}$token${data.millisecondsSinceEpoch}.jpg");

    final UploadTask uploadTask = ref.putFile(image!);

    TaskSnapshot snap = await uploadTask;

    var url = uploadTask.snapshot.ref.getDownloadURL();

    return url;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.orange,
        statusBarIconBrightness: Brightness.light));
    Future.delayed(Duration(milliseconds: 500), () async {
      setState(() {
        _progress = null;
      });
      await loadCategorys();
      if (produto != null) {
        var split = produto!.preco.toString().split(".");

        if (split[1].length == 0)
          split[1] = "00";
        else if (split[1].length < 2) split[1] = "${split[1]}0";

        var preco = "${split[0]}${split[1]}";
        print(preco);

        if (preco.length == 4) precoCon.mask = "R\$00,00";

        if (preco.length == 5) precoCon.mask = "R\$000,00";

        nomeCon.text = produto!.nome!;
        descCon.text = produto!.descricao!;
        precoCon.updateText(preco);

        if (categorys.length > 0) {
          for (var i = 0; i < categorys.length; i++) {
            if (categorys[i].nome == produto!.categoria) {
              setState(() {
                value = i;
              });
              break;
            }
          }
        }

        var path = await (getExternalStorageDirectory() as FutureOr<Directory>);

        var time = DateTime.now().millisecondsSinceEpoch.toString();
        File file = new File("${path.path}/${time}.png");

        print(file.path);

        Response response = await http.get(Uri.parse(produto!.image!));
        file.writeAsBytes(response.bodyBytes);

        setState(() {
          image = file;
          _progress = 0.0;
        });
      } else {
        setState(() {
          _progress = 0.0;
        });
      }
    });

    precoCon.beforeChange = (a, text) {
      if (text.length == 7)
        precoCon.updateMask("R\$00,00");
      else if (text.length > 7)
        precoCon.updateMask("R\$000,00");
      else
        precoCon.updateMask("R\$0,00");

      return true;
    };
  }

  loadCategorys() async {
    try {
      var result = await produtoController.listCategorys();
      print(result);
      if (result != null) {
        setState(() {
          categorys = result;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Não encontramos nenhuma categoria",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.deepOrange));
      }
    } catch (e) {
      print(e);
    }
  }

  var _preparar = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(value: _progress),
        Container(
          padding: EdgeInsets.all(28),
          child: ListView(
            children: [
              image == null
                  ? GestureDetector(
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.orange,
                        size: 90,
                      ),
                      onTap: () => getImage(),
                    )
                  : GestureDetector(
                      child: Container(
                        width: size.width / 3,
                        child: Image.file(image!,
                            width: size.width / 3, height: size.width / 3),
                      ),
                      onTap: () => getImage(),
                    ),
              SizedBox(
                height: 30,
              ),
              TextField(
                textCapitalization: TextCapitalization.words,
                maxLines: 1,
                controller: nomeCon,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    hintText: "nome",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: descCon,
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: "descrição",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: precoCon,
                maxLines: 1,
                keyboardType: TextInputType.number,
                onChanged: (text) {},
                decoration: InputDecoration(
                    hintText: "preço",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)))),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      items: List.generate(categorys.length, (index) {
                        var category = categorys[index];

                        return DropdownMenuItem(
                          child: Container(
                            width: double.infinity,
                            child: Text(category.nome!),
                          ),
                          value: index,
                        );
                      }),
                      onChanged: (dynamic val) {
                        setState(() {
                          value = val;
                        });
                      },
                      hint: Text(categorys[value!].nome!),
                    ),
                  ),
                  /* Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        var r = await Navigator.of(context).push(
                            PageRouteBuilder(
                                opaque: false,
                                fullscreenDialog: true,
                                pageBuilder: (ctx, a1, a2) => NovaCategoria()));
                        if (r) loadCategorys();
                      },
                    ),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  )
                  */
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  child: FlatButton(
                padding: EdgeInsets.all(12),
                color: Colors.orange,
                child: Text(produto != null ? "Atualizar" : "Cadastrar",
                    style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  save();
                },
              )),
              produto != null
                  ? Container(
                      child: FlatButton(
                      padding: EdgeInsets.all(12),
                      color: Colors.red,
                      child: Text("Deletar",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        try {
                          var result = await produtoController.delete(produto!);
                          if (result)
                            Navigator.pop(context);
                          else
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  duration: Duration(milliseconds: 1500),
                                  backgroundColor: Colors.orange,
                                  content: Text(
                                    "Produto não deletado",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                duration: Duration(milliseconds: 1500),
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Falha de conexão",
                                  style: TextStyle(color: Colors.white),
                                )),
                          );
                        }
                      },
                    ))
                  : SizedBox()
            ],
          ),
        ),
        _progress == null
            ? Container(
                color: Colors.black.withOpacity(0.5),
              )
            : SizedBox()
      ],
    ));
  }
}
