import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutterappbookstore/base/base_bloc.dart';
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutterappbookstore/data/repo/user_repo.dart';
import 'package:flutterappbookstore/event/signin_event.dart';
import 'package:flutterappbookstore/event/signin_fail_event.dart';
import 'package:flutterappbookstore/event/signin_success_event.dart';
import 'package:flutterappbookstore/event/signup_event.dart';
import 'package:flutterappbookstore/shared/validation.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc extends BaseBloc with ChangeNotifier{

  final _passSubject  = BehaviorSubject<String>();
  final _emailSubject  = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();
  final _phoneSubject = BehaviorSubject<String>();

  UserRepo _userRepo ;

  SignInBloc({@required UserRepo userRepo}) {
    _userRepo = userRepo;
    //validateForm();
    validateForm2();
  }

  var phoneValidation = StreamTransformer<String,String>.fromHandlers(
    handleData: (phone,sink){
      if(Validation.isPhoneValid(phone)){
        sink.add(null);
        return;
      }
      sink.add("Phone invalid");
    }
  );

  var passValidation = StreamTransformer<String,String>.fromHandlers(
      handleData: (pass,sink){
        if(Validation.isPassValid(pass)){
          sink.add(null);
          return;
        }
        sink.add("Password to sort");
      }
  );

  var emailValidation = StreamTransformer<String,String>.fromHandlers(
      handleData: (email,sink){
        if(Validation.isEmailValid(email)){
          sink.add(null);
          return;
        }
        sink.add("Email is not correct");
      }
  );

  Stream<String> get phoneStream => _phoneSubject.stream.transform(phoneValidation);
  Sink<String> get phoneSink => _phoneSubject.sink;

  Stream<String> get passStream => _passSubject.stream.transform(passValidation);
  Sink<String> get passSink => _passSubject.sink;

  Stream<String> get emailStream => _emailSubject.stream.transform(emailValidation);
  Sink<String> get emailSink => _emailSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  validateForm(){
    Rx.combineLatest2(
        _emailSubject, _passSubject, (email, pass) {
          return Validation.isEmailValid(email) && Validation.isPassValid(pass);
    }
    ).listen((enable) {
      btnSink.add(enable);
    });
  }

  validateForm2(){
    Rx.combineLatest2(_phoneSubject,_passSubject,(phone,pass){
      return Validation.isPhoneValid(phone) && Validation.isPassValid(pass);
    }).listen((enable) {
      btnSink.add(enable);
    },);
  }

  @override
  void dispatchEvent(BaseEvent event) {
    // TODO: implement dispatchEvent
    switch(event.runtimeType){
      case SignInEvent:
        handleSignIn(event);
        break;
      case SignUpEvent:
        handleSignUp(event);
        break;
    }
  }

  handleSignIn(event){

    btnSink.add(false); //disable when api was call
    loadingSink.add(true); // show loading

    SignInEvent e = event as  SignInEvent;
    _userRepo.signIn(e.phone, e.pass)  //.then((){},orError:(e){})  as if/else
    .then((userData) {
      print(userData);
      processEventSink.add(SignInSuccessEvent(userData));
    }, onError:(e)
    {
      btnSink.add(true); // reverse or contradictory or counter
      loadingSink.add(false);
      processEventSink.add(SignInFailEvent(e.toString()));
      print(e);
    });
  }

  handleSignUp(event){

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _passSubject.close();
    _emailSubject.close();
    _btnSubject.close();
    _phoneSubject.close();
  }
}