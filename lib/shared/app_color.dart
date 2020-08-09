import 'dart:ui';
import 'package:flutter/material.dart';

class AppColor{
  static Map<int,Color> color ={
    50 : Color.fromRGBO(136, 14, 79, .1),
    100 : Color.fromRGBO(136, 14, 79, .2),
    200 : Color.fromRGBO(136, 14, 79, .3),
    300 : Color.fromRGBO(136, 14, 79, .4),
    400 : Color.fromRGBO(136, 14, 79, .5),
    500 : Color.fromRGBO(136, 14, 79, .6),
    600 : Color.fromRGBO(136, 14, 79, .7),
    700 : Color.fromRGBO(136, 14, 79, .8),
    800 : Color.fromRGBO(136, 14, 79, .9),
    900 : Color.fromRGBO(136, 14, 79, 1),
  };

  static MaterialColor yellow = MaterialColor(0xffffeb3b, color);
  static MaterialColor blue = MaterialColor(0xff2196f3, color);
  static MaterialColor red = MaterialColor(0xfff44336, color);
  static MaterialColor black = MaterialColor(0xff000000,color);
  static MaterialColor white = MaterialColor(0xffffffff,color);
  static MaterialColor green = MaterialColor(0xff4caf50,color);
  static MaterialColor brown = MaterialColor(0xff795548,color);
}