import 'package:flutter/material.dart';

class PaymentSuccess extends StatefulWidget {
  @override
  _PaymentSucessState createState() => _PaymentSucessState();
}

class _PaymentSucessState extends State<PaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/checked.png",
                color: Colors.orange,
                width: size.width * 0.4,
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(28),
                child: Text(
                  "Tudo pronto, agora é só relaxar e esperar o seu pedido",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Meus Pedidos"))
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset("assets/images/relaxing.png"),
          ),
        ],
      ),
    );
  }
}
