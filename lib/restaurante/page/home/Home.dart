import 'package:cardapio/api/controller/MesaController.dart';
import 'package:cardapio/api/socket/ConnectionManager.dart';
import 'package:cardapio/api/socket/ModelNotify.dart';
import 'package:cardapio/api/socket/NotificationManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'model/MesaItem.dart';
import 'model/NovaMesa.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var mesas = [];

  var numeroController = TextEditingController();
  GetIt it = GetIt.instance;

  MesaController mesaController = MesaController();
  FlutterSecureStorage storage = FlutterSecureStorage();
  ModelNotify modelNotify = ModelNotify();

  dynamic loading = null;
  String? type = "";
  @override
  void initState() {
    super.initState();
    modelNotify.notify = notify;
    it.registerSingleton(modelNotify);

    listMesas();

    Future.delayed(Duration(milliseconds: 100), () {
      loadType();
    });
  }

  loadType() async {
    try {
      var t = await storage.read(key: "type");
      setState(() {
        type = t;
      });
    } catch (e) {}
  }

  notify(json) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(json['text']),
      duration: Duration(hours: 1),
      action: SnackBarAction(
        onPressed: () {},
        label: "Atender",
      ),
    ));
  }

  @override
  deactivate() {
    super.deactivate();
    if (it.isRegistered(instance: modelNotify))
      it.unregister(instance: modelNotify);
  }

  listMesas() async {
    try {
      var result = await mesaController.mesas();
      if (result != null) {
        setState(() {
          mesas = result;
        });
      } else {
        mesas = [];
      }
      setState(() {
        loading = 0.0;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = 0.0;
        });
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Mesas",
          style: TextStyle(color: Colors.white),
        ),
        leading: SizedBox(),
        leadingWidth: 0,
        actions: [
          type == "garcom"
              ? IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await storage.deleteAll();
                    try {
                      it<ConnectionManager>().close();
                      await it.unregister<ConnectionManager>();
                      await it.reset();
                    } catch (e) {
                      print(e);
                    }
                    Navigator.of(context).pushReplacementNamed("login");
                  },
                )
              : SizedBox()
        ],
      ),
      body: loading == null
          ? Center(
              child: CircularProgressIndicator(
                value: loading,
              ),
            )
          : RefreshIndicator(
              onRefresh: () => listMesas(),
              child: mesas.length > 0
                  ? GridView.builder(
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (context, i) {
                        return MesaItem(mesas[i], context, listMesas);
                      },
                      itemCount: mesas.length,
                    )
                  : ListView(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          alignment: Alignment.center,
                          child: Text(
                            "Nenhuma mesa aqui ainda!",
                            style: TextStyle(fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          var res = await showGeneralDialog(
              context: context,
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return NovaMesa(context, null);
              });
          if (res as bool) listMesas();
        },
      ),
    );
  }
}
