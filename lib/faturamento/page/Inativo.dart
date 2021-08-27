import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Inativo extends StatefulWidget {
  @override
  _InativoState createState() => _InativoState();
}

class _InativoState extends State<Inativo> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            "image/emoji_piscada.png",
            width: size.width * 0.4,
            height: size.width * 0.4,
          ),
          Container(
            padding: EdgeInsets.all(40),
            child: Text(
              "Parece que há débitos pendentes em sua assinatura, visite a opção Pagamentos no painel para resolver esse problema e voltar aos negócios!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w100,
                  fontSize: 18),
            ),
          ),
          Container(
            padding: EdgeInsets.all(40),
            child: FlatButton(
              child: Text(
                "PROSSEGUIR",
                style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
              ),
              padding: EdgeInsets.all(10),
              minWidth: double.infinity,
              onPressed: () async {
                var type = await storage.read(key: "type");
                if (type == "gerente") {
                  if (type == "admin" || type == "gerente")
                    Navigator.of(context).pushReplacementNamed("painel");
                  else if (type == "garcom")
                    Navigator.of(context).pushReplacementNamed("home");
                  else if (type == "cozinha")
                    Navigator.of(context).pushReplacementNamed("cozinha");
                } else {
                  Navigator.of(context).pushReplacementNamed("login");
                }
              },
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
