import 'dart:async';

import 'package:cardapio/api/controller/PaymentController.dart';
import 'package:flutter/material.dart';

class ChoicePayment extends StatefulWidget {
  @override
  _ChoicePaymentState createState() => _ChoicePaymentState();
}

class _ChoicePaymentState extends State<ChoicePayment> {
  Future<bool> checkGoogleAvaiable() async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: Container(
        height: size.height / 2,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Text("Escolha  a forma de pagamento",
                  style: TextStyle(fontSize: 16)),
            ),
            Expanded(
              child: FutureBuilder(
                builder: (context, snap) {
                  if (snap.hasData) {
                    return ListView(
                      children: [
                        Visibility(
                          visible: snap.data as bool,
                          child: Card(
                            child: ListTile(
                              title: Text("Google Pay"),
                              leading: Image.asset(
                                "assets/images/gpay.png",
                                width: 40,
                              ),
                              onTap: () {
                                Navigator.of(context).pop(0);
                              },
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: Text("Cartão de Crédito"),
                            leading: Image.asset(
                              "assets/images/credit-card.png",
                              width: 40,
                            ),
                            onTap: () {
                              Navigator.of(context).pop(1);
                            },
                          ),
                        )
                      ],
                    );
                  } else if (snap.connectionState == ConnectionState.waiting) {
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
                future: checkGoogleAvaiable(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
