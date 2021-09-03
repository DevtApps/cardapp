import 'package:cardapio/api/controller/PaymentController.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:cardapio/usuario/page/home/results/PaymentSuccess.dart';
import 'package:cardapio/usuario/page/home/resume/ResumeDeliveryModel.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'ResumeArgs.dart';

class ResumeDeliveryView extends StatefulWidget {
  @override
  _ResumeDeliveryViewState createState() => _ResumeDeliveryViewState();
}

class _ResumeDeliveryViewState extends ResumeDeliveryModel {
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ResumeArgs?;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        brightness: Brightness.dark,
        title: Text(
          "Resumo",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            padding: EdgeInsets.all(4),
            children: [
              Card(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text("Entregar em"),
                      ),
                      Expanded(
                        flex: 3,
                        child: Wrap(children: [
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                endereco != null
                                    ? endereco!.formatted
                                    : "Selecionar",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            onTap: () {
                              choiceAddress();
                            },
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Expanded(child: Text("Subtotal")),
                            Text(
                              currency.format((getAmount() / 100).toDouble()),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text("Entrega")),
                            Text(currency.format(tax))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "TOTAL",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            Text(
                              currency
                                  .format((getAmount() / 100).toDouble() + tax),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text("Pagar com"),
                      ),
                      GestureDetector(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (cardToken != null)
                                  Image.asset(
                                    cardToken is Token
                                        ? "assets/images/gpay.png"
                                        : "assets/images/credit-card.png",
                                    width: size.width * 0.11,
                                  ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  cardToken != null
                                      ? cardToken.card.last4
                                      : "Selecionar",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ],
                            )),
                        onTap: () {
                          choicePaymentMethod();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                      children: List.generate(args!.pedidos.length, (index) {
                    PedidoDelivery pedido = args!.pedidos[index];

                    return Container(
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              pedido.produto!.nome!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: pedido.observacao!.length > 0,
                            child: Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Observações",
                                    ),
                                  ),
                                  Text(
                                    pedido.observacao!,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    maxLines: 2,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Quantidade",
                                  ),
                                ),
                                Text(
                                  "${pedido.quantidade}",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Valor Unidade",
                                  ),
                                ),
                                Text(
                                  "${currency.format(pedido.produto!.preco)}",
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Valor",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${currency.format(pedido.quantidade! * pedido.produto!.preco!)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (index < args!.pedidos.length - 1) Divider(),
                        ],
                      ),
                    );
                  })),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            color: Colors.orange,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.orangeAccent),
              ),
              child: Text(
                "Finalizar",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (cardToken == null) {
                  showError("Informe um endereço para entrega!");
                  return;
                }
                if (endereco == null) {
                  showError("Informe um meio de pagamento!");
                  return;
                }

                var result = await PaymentController(
                        context, args!.pedidos, endereco, cardToken, tax)
                    .pay();

                if (result) {
                  await Navigator.of(context).pushNamed("success");
                  Navigator.of(context).pop();
                } else
                  showDialog(
                      context: context,
                      builder: (c) {
                        return AlertDialog(
                          content: Text(
                              "Não foi possível concluír o pagamento, tente um novo método de pagamento!"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(c);
                                },
                                child: Text("OK"))
                          ],
                        );
                      });
              },
            ),
          ),
        ],
      ),
    );
  }
}
