import 'package:flutter/material.dart';
import 'package:flutterappbookstore/shared/app_color.dart';

class BtnStyle{
  static TextStyle normal(){
    return TextStyle(fontSize: 17,color: AppColor.blue);
  }

  static TextStyle small(){
    return TextStyle(fontSize: 13,color: AppColor.blue);
  }

  static TextStyle large(){
    return TextStyle(fontSize: 25,color: AppColor.blue);
  }
}