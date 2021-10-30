import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CardFormView extends StatefulWidget {
  @override
  _CardFormViewState createState() => _CardFormViewState();
}

class _CardFormViewState extends State<CardFormView> {
  TextEditingController cardNumberController = MaskedTextController();
  MaskedTextController cardExpiresController =
      MaskedTextController(mask: "00/00");
  MaskedTextController cardCvvController = MaskedTextController(mask: "000");

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Card(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: TextFormField(
                  controller: cardNumberController,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Container(
                    child: TextFormField(
                      controller: cardExpiresController,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    child: TextFormField(
                      controller: cardCvvController,
                    ),
                  ),
                ],
              ),
              Card(
                child: Container(
                  width: double.infinity,
                  child: TextButton(
                    child: Text("CONTINUAR"),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
