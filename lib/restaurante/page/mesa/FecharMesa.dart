import 'package:cardapio/api/controller/MesaController.dart';
import 'package:flutter/material.dart';

MesaController mesaController = MesaController();
Widget FecharMesa(ctx, mesa){
  return AlertDialog(
    contentPadding: EdgeInsets.only(top:12, left: 8, right: 8),
    content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Limpar Mesa?"),
            SizedBox(height: 10,),
            Row(children: [
              Expanded(
                child: FlatButton(
                  child:Text("CANCELAR"),
                  onPressed: (){
                    Navigator.pop(ctx);
                  },
                ),

              ),
              Expanded(
                child: FlatButton(
                  child:Text("OK"),
                  onPressed: ()async{
                    var result = await mesaController.clear(mesa.id);
                    Navigator.of(ctx).pop(result);

                  },
                ),

              )

            ],)
          ],
    ),
  );
}