import 'dart:convert';

import 'package:cardapio/api/Api.dart';
import 'package:cardapio/api/controller/DeliveryController.dart';
import 'package:cardapio/usuario/model/PedidoDelivery.dart';

import 'package:cardapio/usuario/page/home/perfil/endereco/model/Endereco.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentController {
  DeliveryController deliveryController = DeliveryController();
  BuildContext context;
  List<PedidoDelivery> pedidos;
  Endereco endereco;
  var cardToken;
  var tax = 0.0;

  FlutterSecureStorage storage = FlutterSecureStorage();

  var host = HOST + "/payment";
  PaymentController(
      this.context, this.pedidos, this.endereco, this.cardToken, this.tax) {}

  Future<String> getToken() async {
    return await storage.read(key: "token");
  }

  Future<bool> pay() async {
    try {
      var token = "";
      var payment_id = "";
      if (cardToken is Token)
        token = cardToken.tokenId;
      else {
        payment_id = cardToken.id;
      }

      var payment = await completePayment(token: token, payment_id: payment_id);
      if (payment != null) {
        print(payment);
        var result = await postDelivery(payment['payment']);
        if (result) {
          return true;
        } else {
          refund(payment['id']);
          return false;
        }
      } else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> refund(id) async {
    var result = await post(
      Uri.parse(host),
      body: {"payment": id},
      headers: {
        "token": await getToken(),
      },
    );
    print(result.body);
  }

  getShopId() {
    return pedidos[0].produto.gerente;
  }

  int getAmount() {
    double amount = 0.0;
    for (var pedido in pedidos) {
      amount += pedido.produto.preco * pedido.quantidade;
    }
    amount = amount * 100;
    return amount.toInt();
  }

  Future<bool> postDelivery(payment) async {
    var postPedido =
        await deliveryController.novoPedido(pedidos, endereco, payment, tax);
    if (postPedido) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map> completePayment({token, payment_id}) async {
    String amount = getAmount().toString();
    var shopId = getShopId();
    var result = await post(Uri.parse(host), body: {
      "card_token": token,
      "amount": amount,
      "shop_id": shopId,
      "payment_id": payment_id
    }, headers: {
      "token": await getToken()
    });

    if (result.statusCode == 200) {
      return jsonDecode(result.body);
    } else {
      return null;
    }
  }

  createPaymentCard() async {
    await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    ).then((PaymentMethod paymentMethod) {
      print(paymentMethod.id);
      return paymentMethod;
    }).catchError((e) {
      print('Errore Card: ${e.toString()}');
    });
  }

  Future<Token> createPaymentMethodNative(pedidos) async {
    StripePayment.setStripeAccount(null);
    List<ApplePayItem> apple = [];

    var amount = 0.0;
    for (var pedido in pedidos) {
      amount += (pedido.quantidade * pedido.produto.preco);
    }

    apple.add(ApplePayItem(label: "Pedidos", amount: amount.toString()));
    apple.add(ApplePayItem(label: "Tax. Entrega", amount: 3.0.toString()));
    apple.add(ApplePayItem(label: "Total", amount: (amount + 3.0).toString()));

    amount += 3.0;

    Token token = await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
          currencyCode: "BRL", totalPrice: amount.toString()),
      applePayOptions:
          ApplePayPaymentOptions(countryCode: "BR", currencyCode: "BRL"),
    );

    return token;
  }
}
