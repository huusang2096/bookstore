import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterappbookstore/data/remote/user_service.dart';
import 'package:flutterappbookstore/data/spref/spref.dart';
import 'package:flutterappbookstore/shared/constant.dart';
import 'package:flutterappbookstore/shared/model/user_data.dart';

class UserRepo{
  UserService _userService;

  UserRepo({@required UserService userService}) : _userService = userService;

  //edit email = phone
  Future<UserData> signIn(String phone,String pass) async {
    var c = Completer<UserData>();

    try {
      var response = await _userService.signIn(phone, pass);
      var userData = UserData.fromJson(response.data['data']);
      if (userData != null) {
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token);
        c.complete(userData);
      }
    }on DioError catch(e){
      print(e.response.data);
      c.completeError('Sign In Fail');

    }catch(e){
      c.completeError(e);
    }

    return c.future;
  }

  Future<UserData> signUp(String displayName,String phone,String pass) async{
    var c = Completer<UserData>();
    try{
      var response = await _userService.signUp(displayName, phone, pass);
      var userData = UserData.fromJson(response.data['data']);
      if(userData != null){
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token);
        c.complete(userData);
      }
    }on DioError catch (e){
      print(e.response.data);
      c.completeError('Sign Up Fail');
    }catch (e){
      c.completeError(e);
    }
    return c.future;
  }
}