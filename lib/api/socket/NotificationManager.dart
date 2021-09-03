import 'package:cardapio/api/socket/ConnectionManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class NotificationManager extends ChangeNotifier {
  var token;
  GetIt it = GetIt.instance;
  ConnectionManager? connectionManager;
  var message = "";

  NotificationManager() {
    connectionManager = it<ConnectionManager>();
    connectionManager!.onMessage = (json) {
      message = json;
      notifyListeners();
    };
  }
}
