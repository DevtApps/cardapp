import 'package:cardapio/api/controller/MesaController.dart';
import 'package:flutter/material.dart';

TextEditingController numeroController = TextEditingController();
MesaController mesaController = MesaController();
Widget NovaMesa(context, mesa) {
  if (mesa != null) numeroController.text = "${mesa.numero}";
  return Center(
    child: Card(
      margin: EdgeInsets.all(28),
      child: Container(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nova Mesa",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: numeroController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "N° Mesa",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)))),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              minWidth: double.maxFinite,
              color: Colors.orange,
              child: Text(mesa != null ? "Atualizar" : "Criar",
                  style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (numeroController.text.length < 1) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Dê um número a mesa"),
                  ));
                  return;
                }
                var result =
                    await mesaController.novaMesa(numeroController.text, mesa);
                if (result) {
                  numeroController.text = "";
                  Navigator.of(context).pop(true);
                } else
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Mesa não criada"),
                  ));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FlatButton(
                    color: Colors.orange,
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                SizedBox(width: mesa != null ? 10 : 0),
                mesa != null
                    ? Expanded(
                        child: FlatButton(
                        color: Colors.red,
                        child: Text(
                          "Apagar",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          var result = await mesaController.delete(mesa);
                          if (result) {
                            Navigator.of(context).pop(true);
                          } else
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Mesa não deletada"),
                            ));
                        },
                      ))
                    : SizedBox(),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
