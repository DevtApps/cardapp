import 'package:cardapio/api/model/Mesa.dart';
import 'package:cardapio/api/model/Pedido.dart';
import 'package:cardapio/restaurante/page/mesa/MesaPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NovaMesa.dart';

Widget MesaItem(Mesa mesa, context, loadMesas) {
  var notify = false;
  for (var p in mesa.itens) {
    Pedido pedido = Pedido.fromJson(p);
    if (pedido.status == 2) {
      notify = true;
      break;
    }
  }
  return GestureDetector(
    child: Stack(
      children: [
        Card(
          child: Column(
            children: [
              Flexible(
                flex: 3,
                child: Center(
                    child:
                        /*mesa.itens.length == 0
                      ? SvgPicture.asset(
                    "image/dining-table.svg",
                    color: Colors.orange,
                    width: 50,
                  )
                      : */
                        Icon(
                  Icons.group,
                  color: Colors.orange,
                  size: 50,
                )),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  "MESA ${mesa.numero}",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.topRight,
            child: notify
                ? Icon(
                    Icons.notifications,
                    color: Colors.orange[800],
                    size: 20,
                  )
                : SizedBox())
      ],
    ),
    onTap: () async {
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MesaPage(mesa)));
      loadMesas();
    },
    onLongPress: () async {
      var res = await showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return NovaMesa(context, mesa);
          });
      if (res as bool) loadMesas();
    },
  );
}
