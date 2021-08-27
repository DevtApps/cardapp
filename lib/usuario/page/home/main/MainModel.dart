
import 'package:flutter/material.dart';
import 'MainView.dart';

abstract class MainModel extends State<MainView>{
  var nextPedidos;
  MainModel(this.nextPedidos);

  Size size;
}