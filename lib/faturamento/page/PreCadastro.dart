import 'package:cardapio/api/controller/UserController.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class PreCadastro extends StatefulWidget {
  @override
  _PreCadastroState createState() => _PreCadastroState();
}

class _PreCadastroState extends State<PreCadastro> {
  FocusNode nomeNode = FocusNode();
  FocusNode cpfNode = FocusNode();

  MaskedTextController cpfController =
      MaskedTextController(mask: "000.000.000-00");
  TextEditingController nomeController = TextEditingController();

  PageController pageController = PageController(initialPage: 0);

  var loading = false;
  var page = 0;

  UserController controller = UserController();

  preRegistro() async {
    try {
      if (nomeController.text.split(" ").length > 1 &&
          cpfController.text.length == 14) {
        if (CPF.isValid(cpfController.text)) {
          loading = true;
          update();

          var result = await controller.preDados(
              nomeController.text, cpfController.text);
          if (result == null) {
            loading = false;
            update();
            show("Este cpf já esta em uso!");
          } else if (result) {
            Navigator.of(context).pushReplacementNamed("wellcome");
          } else {
            loading = false;
            update();
            show("Houve um erro com seu registro, tente novamente!");
          }
        } else
          show("CPF inválido");
      } else {
        show("Complete os dados corretamente");
      }
    } catch (e) {
      loading = false;
      update();
    }
  }

  update() {
    if (mounted) {
      setState(() {
        page = 0;
      });
    }
  }

  show(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.deepOrange,
      duration: Duration(milliseconds: 1500),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange.withBlue(600),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.all(30),
              child: Text(
                loading
                    ? "Validando Dados"
                    : page == 0
                        ? "Estamos perto"
                        : "Só mais um passo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w100),
              ),
            ),
            Expanded(
                child: loading
                    ? Center(
                        child: CircularProgressIndicator(
                        value: null,
                        backgroundColor: Colors.white,
                      ))
                    : PageView(
                        onPageChanged: (p) {
                          setState(() {
                            page = p;
                          });
                        },
                        physics: NeverScrollableScrollPhysics(),
                        pageSnapping: false,
                        controller: pageController,
                        children: [
                          Container(
                            padding: EdgeInsets.all(30),
                            child: Center(
                              child: TextField(
                                textCapitalization: TextCapitalization.words,
                                focusNode: nomeNode,
                                controller: nomeController,
                                cursorColor: Colors.white,
                                style: TextStyle(
                                    color: Colors.white, fontFamily: "Poppins"),
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    labelText: "Nome Completo",
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins"),
                                    alignLabelWithHint: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(30),
                            child: Center(
                              child: TextField(
                                focusNode: cpfNode,
                                controller: cpfController,
                                cursorColor: Colors.white,
                                style: TextStyle(
                                    color: Colors.white, fontFamily: "Poppins"),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: "CPF",
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins"),
                                    alignLabelWithHint: true,
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                              ),
                            ),
                          ),
                        ],
                      )),
            !loading
                ? GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        page == 1 ? "INICIAR" : "AVANÇAR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    onTap: () {
                      if (page == 0) {
                        if (nomeController.text.split(" ").length > 1) {
                          nomeNode.unfocus();
                          cpfNode.unfocus();
                          pageController.animateToPage(1,
                              duration: Duration(milliseconds: 700),
                              curve: Curves.decelerate);
                        } else {
                          show("Complete seu nome");
                        }
                      } else {
                        preRegistro();
                      }
                    },
                  )
                : SizedBox(),
            !loading
                ? GestureDetector(
                    child: AnimatedContainer(
                      height: page == 1 ? 50 : 0,
                      duration: Duration(milliseconds: 600),
                      curve: Curves.fastOutSlowIn,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "VOLTAR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    onTap: () {
                      nomeNode.unfocus();
                      cpfNode.unfocus();
                      pageController.animateToPage(0,
                          duration: Duration(milliseconds: 700),
                          curve: Curves.decelerate);
                    },
                  )
                : SizedBox(),
            SizedBox(height: 20)
          ],
        ));
  }
}
