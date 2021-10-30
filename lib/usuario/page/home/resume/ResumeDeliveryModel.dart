import 'package:cardapio/fastfire/models/UserStateModel.dart';
import 'package:cardapio/usuario/fragments/ChoiceAddress.dart';
import 'package:cardapio/usuario/fragments/ChoicePayment.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';
import 'package:cardapio/usuario/page/home/perfil/endereco/model/Endereco.dart';
import 'package:cardapio/usuario/page/home/resume/ResumeArgs.dart';
import 'package:cardapio/usuario/page/home/resume/ResumeDeliveryView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';

abstract class ResumeDeliveryModel extends State<ResumeDeliveryView>
    with UserStateModel {
  ResumeArgs? args;
  NumberFormat currency = NumberFormat.currency(symbol: "R\$", locale: "pt_BR");
  var tax = 3.0;
  Endereco? endereco = null;
  dynamic cardToken = null;

  int getAmount() {
    double amount = 0.0;
    for (var pedido in args!.pedidos) {
      amount += pedido.produto!.preco! * pedido.quantidade!;
    }
    amount = amount * 100;
    return amount.toInt();
  }

  void choiceAddress() async {
    endereco = await showModalBottomSheet(
        context: context,
        builder: (c) {
          return ChoiceAddres();
        });
    if (endereco != null) {
      setState(() {});
    }
  }

  void choicePaymentMethod() async {
    var type = await showModalBottomSheet(
        context: context,
        builder: (c) {
          return ChoicePayment();
        });
    if (type != null) {
      try {
        switch (type) {
          case 0:
            {
              /* Token token = await createPaymentMethodNative();
              if (token != null)
                setState(() {
                  cardToken = token;
                });
                */

              break;
            }
          case 1:
            {
              PaymentMethod method = await createPaymentCard();
              if (method != null) {
                setState(() {
                  cardToken = method;
                });
              }

              break;
            }
        }
      } catch (e) {}
    }
  }

  Future<void> createPaymentMethodNative() async {
    // StripePayment.setStripeAccount("");

/*
    var amount = 0.0;
    for (var pedido in args!.pedidos) {
      amount += (pedido.quantidade! * pedido.produto!.preco!);
    }
    amount += tax;
    Token token = await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
          currencyCode: "BRL", totalPrice: (amount * 100).toInt().toString()),
      applePayOptions:
          ApplePayPaymentOptions(countryCode: "BR", currencyCode: "BRL"),
    );

    return token;
    */
  }

  createPaymentCard() async {
    PaymentMethod method = await Stripe.instance.createPaymentMethod(
        PaymentMethodParams.card(
            billingDetails: BillingDetails(email: auth.currentUser!.email)));

    return method;
  }

  showError(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        onPressed: () {},
        label: "OK",
      ),
    ));
  }
}
