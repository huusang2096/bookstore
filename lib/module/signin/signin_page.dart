
import 'package:flutter/material.dart';
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutterappbookstore/base/base_widget.dart';
import 'package:flutterappbookstore/data/remote/user_service.dart';
import 'package:flutterappbookstore/data/repo/user_repo.dart';
import 'package:flutterappbookstore/event/signin_event.dart';
import 'package:flutterappbookstore/event/signin_fail_event.dart';
import 'package:flutterappbookstore/event/signin_success_event.dart';
import 'package:flutterappbookstore/module/signin/signin_bloc.dart';
import 'package:flutterappbookstore/shared/app_color.dart';
import 'package:flutterappbookstore/shared/widget/bloc_listener.dart';
import 'package:flutterappbookstore/shared/widget/loading_task.dart';
import 'package:flutterappbookstore/shared/widget/normal_button.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Sign In',
      di: [
        Provider.value(value: UserService()),
        ProxyProvider<UserService,UserRepo>(
            update: (context,userService,previous) =>
            UserRepo(userService: userService),
        ),
      ],
      bloc: [],
      child: SignInFormWidget(),
    );
  }
}

class SignInFormWidget extends StatefulWidget {
  @override
  _SignInFormWidgetState createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {

  final TextEditingController  _txtEmailController = TextEditingController();
  final TextEditingController  _txtPhoneController = TextEditingController();
  final TextEditingController _txtPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ChangeNotifierProvider(
        create:(_) => SignInBloc(userRepo: Provider.of(context)),
        child: Consumer<SignInBloc>(
          builder:(context,bloc,child) => BlocListener<SignInBloc>(
            listener: handleEvent,
            child: LoadingTask(
              bloc: bloc,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildPhoneField(bloc),
                    _buildPasswordField(bloc),
                    buildSignInButton(bloc),
                    _buildFooterField(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignInButton(SignInBloc bloc){
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) => NormalButton(
          title: "Sign In",
          onPressed:
            enable ? (){
              bloc.event.add(
                SignInEvent(
                    phone: _txtPhoneController.text,
                    pass: _txtPassController.text
                ),
              );
          }         : null ,
        ),
      ),
    );
  }

  Widget _buildFooterField(BuildContext context){
    return Container(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.all(10),
        child: FlatButton(
          onPressed: (){
            Navigator.pushNamed(context, '/sign-up');
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadiusDirectional.circular(4.0),
          ),
          child: Text(
            'Sign Up',
            style: TextStyle(fontSize: 19,color: AppColor.blue),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(SignInBloc bloc){
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.emailStream,
      child: Consumer<String>(
        builder: (context, msg, child ) => Container(
          margin: EdgeInsets.only(bottom: 20),
          child: TextField(
            onChanged: (text){
              bloc.emailSink.add(text);
            },
            controller: _txtEmailController,
            cursorColor: AppColor.black,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(
                Icons.email,
                color: AppColor.blue,
              ),
              errorText: msg,
              hintText: 'example@gmail.com',
              labelText: 'Email',
              labelStyle: TextStyle(color: AppColor.blue),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(SignInBloc bloc){
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.phoneStream,
      child: Consumer<String>(
        builder: (context, msg, child ) => Container(
          margin: EdgeInsets.only(bottom: 20),
          child: TextField(
            onChanged: (text){
              bloc.phoneSink.add(text);
            },
            controller: _txtPhoneController,
            cursorColor: AppColor.black,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(
                Icons.phone,
                color: AppColor.blue,
              ),
              errorText: msg,
              hintText: '+84 901 234 567',
              labelText: 'Phone',
              labelStyle: TextStyle(color: AppColor.blue),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.passStream,
      child: Consumer<String>(
        builder:(context, msg, child) => Container(
          margin: EdgeInsets.only(bottom: 25),
          child: TextField(
            onChanged: (text){
              bloc.passSink.add(text);
            },
            controller: _txtPassController,
            obscureText: true,
            cursorColor: AppColor.black,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock,
                color: AppColor.blue,
              ),
              errorText: msg,
              hintText: 'Password',
              labelText: 'Password',
              labelStyle: TextStyle(color: AppColor.blue),
            ),
          ),
        ),
      ),
    );
  }

  handleEvent(BaseEvent baseEvent){
    switch(baseEvent.runtimeType){
      case SignInSuccessEvent:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case SignInFailEvent:
        final snackBar = SnackBar(
          content: Text(baseEvent.errMessage),
          backgroundColor: AppColor.red,
        );
        Scaffold.of(context).showSnackBar(snackBar);
        break;
    }
  }
}




