import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void simpleSnackBar(BuildContext context, String s){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
}