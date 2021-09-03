import 'package:cardapio/api/controller/UserController.dart';
import 'package:cardapio/api/secure/ModelUser.dart';
import 'package:cardapio/api/socket/ConnectionManager.dart';
import 'package:cardapio/api/socket/NotificationManager.dart';
import 'package:cardapio/login/LoginModel.dart';
import 'package:cardapio/login/Registro.dart';
import 'package:cardapio/restaurante/page/manager/Sobre.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends LoginModel {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    args = ModalRoute.of(context)!.settings.arguments;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(),
          ),
          Image.asset("image/icon.png", width: size.width * 0.2),
          SizedBox(height: 16),
          /*Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Colors.orange,
                  Colors.orange[300],
                  Colors.orange[100],
                  Colors.white
                ],
                    stops: [
                  0.1,
                  0.3,
                  0.6,
                  0.8
                ])),
          ),
          */
          Center(
            child: Container(
              width: size.width * 0.85,
              child: Card(
                child: Container(
                    padding: EdgeInsets.all(26),
                    child: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                  color: Colors.orange[700],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: senha,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: toggle,
                            style: TextStyle(),
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  child: Icon(icon),
                                  onTap: () {
                                    setState(() {
                                      toggle = !toggle;
                                      icon =
                                          toggle ? Icons.lock : Icons.lock_open;
                                    });
                                  },
                                ),
                                labelText: "Password",
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.orange))),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          value == null
                              ? CircularProgressIndicator(value: value)
                              : TextButton(
                                  onPressed: () {
                                    login();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: size.width,
                                    child: Text(
                                      "ENTRAR",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                    Colors.orange[700],
                                  )),
                                ),
                          GestureDetector(
                            child: Container(
                              child: Text(
                                "Não Tenho Conta",
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                              padding: EdgeInsets.all(4),
                              alignment: Alignment.centerRight,
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  "registro",
                                  arguments: args);
                            },
                          )
                        ],
                      ),
                    )),
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
              alignment: Alignment.bottomCenter,
              child: Text(
                "Termos de uso e Política de privacidade",
                textAlign: TextAlign.center,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => Sobre()));
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                /*
                AndroidIntent intent = AndroidIntent(
                  action: "action_view",
                  data: "https://wa.me/message/NWJOEINH3CWQH1",
                );
                await intent.launch();
                */
              },
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        "assets/images/icon_solo.png",
                        width: size.width * 0.08,
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      //alignment: Alignment.center,
                      child: Text("by AppSide Inc"),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
