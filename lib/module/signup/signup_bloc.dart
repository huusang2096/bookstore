
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterappbookstore/base/base_bloc.dart';
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutterappbookstore/data/repo/user_repo.dart';
import 'package:flutterappbookstore/event/signup_event.dart';
import 'package:flutterappbookstore/event/signup_fail_event.dart';
import 'package:flutterappbookstore/event/signup_success_event.dart';
import 'package:flutterappbookstore/shared/validation.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends BaseBloc with ChangeNotifier{

  final _emailSubject = BehaviorSubject<String>();
  final _phoneSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _fullNameSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  UserRepo _userRepo;

  SignUpBloc({@required UserRepo userRepo}){
    _userRepo = userRepo;
    validationForm();
  }

  var phoneValidation = StreamTransformer<String,String>.fromHandlers(
      handleData: (phone, sink){
        if(Validation.isPhoneValid(phone)){
          sink.add(null);
          return;
        }
        sink.add("Phone must be number and more 9 characters");
      }
  );

  var emailValidation = StreamTransformer<String,String>.fromHandlers(
    handleData: (email, sink){
      if(Validation.isEmailValid(email)){
        sink.add(null);
        return;
      }
      sink.add("Email invalid");
    }
  );

  var passValidation = StreamTransformer<String,String>.fromHandlers(
      handleData: (pass, sink){
        if(Validation.isPassValid(pass)){
          sink.add(null);
          return;
        }
        sink.add("Password to sort");
      }
  );

  var fullNameValidation = StreamTransformer<String,String>.fromHandlers(
      handleData: (fullName, sink){
        if(Validation.isFullNameValid(fullName)){
          sink.add(null);
          return;
        }
        sink.add("FullName to sort");
      }
  );

  Stream<String> get phoneStream => _phoneSubject.stream.transform(phoneValidation);
  Sink<String> get phoneSink => _phoneSubject.sink;

  Stream<String> get emailStream => _emailSubject.stream.transform(emailValidation);
  Sink<String> get emailSink => _emailSubject.sink;

  Stream<String> get passStream => _passSubject.stream.transform(passValidation);
  Sink<String> get passSink => _passSubject.sink;

  Stream<String> get fullNameStream => _fullNameSubject.stream.transform(fullNameValidation);
  Sink<String> get fullNameSink => _fullNameSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  validationForm2(){
    Rx.combineLatest3(
        _emailSubject, _passSubject, _fullNameSubject, (email, pass, fullName) {
          return Validation.isEmailValid(email) && Validation.isPassValid(pass) && Validation.isFullNameValid(fullName);
        }
    ).listen((enable) {
      btnSink.add(enable);
    });
  }

  validationForm(){
    Rx.combineLatest2(
        _phoneSubject, _passSubject, (phone, pass) {
      return Validation.isPhoneValid(phone) && Validation.isPassValid(pass);
    }
    ).listen((enable) {
      btnSink.add(enable);
    });
  }

  @override
  void dispatchEvent(BaseEvent event) {
    // TODO: implement dispatchEvent
    switch(event.runtimeType){
      case SignUpEvent:
        handleSignUp(event);
        break;
    }
  }

  handleSignUp(event){
    btnSink.add(false);
    loadingSink.add(true);

    SignUpEvent e = event as SignUpEvent;
    _userRepo.signUp(e.displayName, e.phone, e.pass)
      .then((userData) {
        //print(userData.fullName);
        processEventSink.add(SignUpSuccessEvent(userData));
      },onError: (e){
        btnSink.add(true);
        loadingSink.add(false);
        processEventSink.add(SignUpFailEvent(e.toString()));
        print(e);
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _emailSubject.close();
    _passSubject.close();
    _fullNameSubject.close();
    _btnSubject.close();
    _phoneSubject.close();
  }

}