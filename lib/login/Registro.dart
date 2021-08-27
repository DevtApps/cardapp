import 'package:cardapio/api/controller/UserController.dart';
import 'package:cardapio/api/secure/ModelUser.dart';
import 'package:cardapio/api/socket/ConnectionManager.dart';
import 'package:cardapio/api/socket/NotificationManager.dart';
import 'package:cardapio/restaurante/page/manager/Sobre.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class Registro extends StatefulWidget {
  Registro();
  @override
  _RegistroState createState() => _RegistroState();
}

class RegistroArgs {
  var type;
  RegistroArgs(this.type);
}

class _RegistroState extends State<Registro> {
  var _toggle = true;
  var icon = Icons.lock;

  TextEditingController email = TextEditingController();
  var senha = TextEditingController();
  var nome = TextEditingController();
  var userController = new UserController();

  FlutterSecureStorage storage = FlutterSecureStorage();
  GetIt it = GetIt.instance;
  var value = 0.0;
  RegistroArgs args;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
  }

  register() async {
    if (email.text.contains("@") &&
        senha.text.length > 5 &&
        nome.text.length > 4) {
      setState(() {
        value = null;
      });
      var user = await userController.register(
          nome.text, email.text, senha.text, "user", null);

      if (user == false) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Verifique os dados e tente novamente!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red));
      } else {
        var type = await storage.read(key: "type");
        var token = await storage.read(key: "token");
        it.registerSingleton(new ModelUser(token));
        it.registerSingleton(new ConnectionManager(token));
        if (type == "user") {
          Navigator.of(context).pushReplacementNamed("home_user");
        } else {

          Navigator.of(context).pushReplacementNamed("precadastro");
        }
      }
      setState(() {
        value = 0.0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Preencha os dados!", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    args = ModalRoute.of(context).settings.arguments;

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
          /* Container(
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
          ),*/
          Center(
            child: Container(
              width: size.width * 0.86,
              child: Card(
                child: Container(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              "REGISTRO",
                              style: TextStyle(
                                  color: Colors.orange[700],
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: nome,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: "Nome",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
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
                            height: 4,
                          ),
                          TextFormField(
                            controller: senha,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _toggle,
                            style: TextStyle(),
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  child: Icon(icon),
                                  onTap: () {
                                    setState(() {
                                      _toggle = !_toggle;
                                      icon = _toggle
                                          ? Icons.lock
                                          : Icons.lock_open;
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
                          TextButton(
                            onPressed: () {
                              register();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: size.width,
                              child: Text(
                                "REGISTRAR",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                              Colors.orange[700],
                            )),
                          ),
                          GestureDetector(
                            child: Container(
                              child: Text(
                                "Já tenho conta",
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                              padding: EdgeInsets.all(4),
                              alignment: Alignment.centerRight,
                            ),
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  "login",
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
          SizedBox(
            height: 12,
          )
          //Center(child: CircularProgressIndicator(value: value)),
        ],
      ),
    );
  }
}
