import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainAppBar{
  String title;
  MainAppBar({this.title});
  Widget myApp(){
    return AppBar(
      title: Text(title),
    );
  }
}