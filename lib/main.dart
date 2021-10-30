import 'package:cardapio/api/secure/ModelUser.dart';
import 'package:cardapio/api/socket/ConnectionManager.dart';
import 'package:cardapio/faturamento/page/Inativo.dart';
import 'package:cardapio/faturamento/page/PreCadastro.dart';
import 'package:cardapio/faturamento/page/WellCome.dart';
import 'package:cardapio/restaurante/page/entregador/EntregadorModel.dart';
import 'package:cardapio/restaurante/page/entregador/EntregadorView.dart';
import 'package:cardapio/usuario/page/home/HomeUser.dart';
import 'package:cardapio/usuario/page/home/locator/LocatorView.dart';
import 'package:cardapio/usuario/page/home/perfil/endereco/EnderecoView.dart';
import 'package:cardapio/usuario/page/home/results/PaymentSuccess.dart';
import 'package:cardapio/usuario/page/home/resume/ResumeDeliveryView.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';

import 'login/LoginView.dart';
import 'login/Registro.dart';
import 'login/Review.dart';
import 'restaurante/page/cozinha/home/PedidosPage.dart';
import 'restaurante/page/home/Home.dart';
import 'restaurante/page/manager/Relatorio.dart';
import 'restaurante/page/painel/Painel.dart';

void main() async {
  Intl.defaultLocale = "pt_BR";

  Stripe.publishableKey = "";
  Stripe.merchantIdentifier = 'MerchantIdentifier';
  Stripe.urlScheme = 'flutterstripe';

  await Stripe.instance.applySettings();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cardapp',
      theme: ThemeData(
        fontFamily: "Poppins",
        primarySwatch: Colors.orange,
      ),
      home: Landing(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      routes: {
        "home": (context) => Home(),
        "login": (context) => LoginView(),
        "registro": (context) => Registro(),
        "painel": (context) => Painel(),
        "cozinha": (context) => PedidosPage(),
        "relatorio": (context) => Relatorio(),
        "precadastro": (context) => PreCadastro(),
        "wellcome": (ctx) => WellCome(),
        "inativo": (ctx) => Inativo(),
        "review": (ctx) => Review(),
        "home_user": (ctx) => HomeUser(),
        "entregador": (ctx) => EntregadorView(),
        "locator": (ctx) => LocatorView(),
        "endereco": (ctx) => EnderecoView(),
        "resume": (ctx) => ResumeDeliveryView(),
        "success": (ctx) => PaymentSuccess(),
      },
    );
  }
}

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  GetIt it = GetIt.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeDateFormatting();

    var PRODUCTION =
        "pk_live_51IdJOZEEmyOoEDXUZ3xQ1Eu93KJ8LJKaJaKVHWEYgnytmls35WwBtuqvYYvkA2aBBtfrVuRSmwyf4hI9WifKz1Hh002UgdWhHH";
    var DEV =
        "pk_test_51IdJOZEEmyOoEDXUigX8RCUCS7YMBrVXdporbn5dIbKEWw2DYpvBuw7iKrZUCM9pqGA3HTRTqBZQfNupW2tEhmea00knFXnKHM";

    Future.delayed(Duration(seconds: 1), () {
      login();
    });
  }

  login() async {
    await Firebase.initializeApp();
    var token = await storage.read(key: "token");
    var registro = await storage.read(key: "registro");

    //Navigator.of(context).pushReplacementNamed("review");

    if (token != null) {
      var type = await storage.read(key: "type");
      it.registerSingleton(new ConnectionManager(token));

      if (registro == null && type == "gerente") {
        Navigator.of(context).pushReplacementNamed("precadastro");
        return;
      }
      if (type == "user") {
        Navigator.of(context).pushReplacementNamed("home_user");
        return;
      }
      if (type == "admin" || type == "gerente")
        Navigator.of(context).pushReplacementNamed("painel");
      else if (type == "garcom")
        Navigator.of(context).pushReplacementNamed("home");
      else if (type == "cozinha")
        Navigator.of(context).pushReplacementNamed("cozinha");
      else if (type == "entregador")
        Navigator.of(context).pushReplacementNamed("entregador");
    } else {
      Navigator.of(context).pushReplacementNamed("review");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
