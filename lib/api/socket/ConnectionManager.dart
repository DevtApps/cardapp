import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/io.dart';

import '../Api.dart';

class ConnectionManager {
  IOWebSocketChannel web;
  String token;

  var onMessage;
  ConnectionManager(this.token) {
    init();

    // so = new WebSocket(SOCKET);
  }

  close() {
    web.sink.close(1000);
    web = null;
  }

  init() {
    web = IOWebSocketChannel.connect(SOCKET, headers: {"token": this.token});
    web.stream.listen((message) {
      var json = jsonDecode(message);
      if (json['action'] != null) {
        if (onMessage != null) {
          onMessage(json);
        }
      }
    }, onError: (error, StackTrace stackTrace) {
      print(error);
    }, onDone: () {
      if (web != null) Future.delayed(Duration(seconds: 3), () => init());
    });
  }

  send(data) {
    print(data);
    web.sink.add(data);
  }
}
