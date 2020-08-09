import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutterappbookstore/base/base_widget.dart';
import 'package:flutterappbookstore/data/remote/user_service.dart';
import 'package:flutterappbookstore/data/repo/user_repo.dart';
import 'package:flutterappbookstore/event/signup_event.dart';
import 'package:flutterappbookstore/event/signup_fail_event.dart';
import 'package:flutterappbookstore/event/signup_success_event.dart';
import 'package:flutterappbookstore/module/home/home_page.dart';
import 'package:flutterappbookstore/module/signup/signup_bloc.dart';
import 'package:flutterappbookstore/shared/app_color.dart';
import 'package:flutterappbookstore/shared/widget/bloc_listener.dart';
import 'package:flutterappbookstore/shared/widget/loading_task.dart';
import 'package:flutterappbookstore/shared/widget/normal_button.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Sign Up',
      di: [
        Provider.value(value: UserService()),
        ProxyProvider<UserService,UserRepo>(
            update: (context,userService,previous) =>
                UserRepo(userService: userService),
        ),
      ],
      bloc: [],
      child: SignUpFormWidget(),
    );
  }
}

class SignUpFormWidget extends StatefulWidget {

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final TextEditingController _txtPhoneController = TextEditingController();

  final TextEditingController _txtEmailController = TextEditingController();

  final TextEditingController _txtPassController = TextEditingController();

  final TextEditingController _txtFullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ChangeNotifierProvider(
        create:(_) => SignUpBloc(userRepo: Provider.of(context)),
        child: Consumer<SignUpBloc>(
          builder: (context,bloc,child) => BlocListener<SignUpBloc>(
            listener: handleEvent,
            child: LoadingTask(
              bloc: bloc,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildFullNameField(bloc),
                    _buildPhoneField(bloc),
                    _buildPassField(bloc),
                    buildSignUpButton(bloc),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.emailStream,
      child: Consumer<String>(
        builder: (context,msg,child) => Container(
          margin: EdgeInsets.all(20),
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
              hintText: "Email input here!",
              labelText: " Email ",
              labelStyle: TextStyle(color: AppColor.blue),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.phoneStream,
      child: Consumer<String>(
        builder: (context,msg,child) => Container(
          margin: EdgeInsets.all(20),
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
              hintText: "Phone input here!",
              labelText: " Phone ",
              labelStyle: TextStyle(color: AppColor.blue),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPassField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.passStream,
      child: Consumer<String>(
        builder: (context,msg,child) => Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: TextField(
            onChanged: (text){
              bloc.passSink.add(text);
            },
            controller: _txtPassController,
            cursorColor: AppColor.black,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock,
                color: AppColor.blue,
              ),
              errorText: msg,
              hintText: ' Password must be more 8 characters',
              labelText: ' Password ',
              labelStyle: TextStyle(color: AppColor.blue),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullNameField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.fullNameStream,
      child: Consumer<String>(
        builder:(context, msg, child) => Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: TextField(
            onChanged: (text){
              bloc.fullNameSink.add(text);
            },
            controller: _txtFullNameController,
            keyboardType: TextInputType.text,
            cursorColor: AppColor.black,
            decoration: InputDecoration(
              icon: Icon(
                Icons.face,
                color: AppColor.blue,
              ),
              labelText: " Full Name ",
              errorText: msg,
              hintText: "Full Name must be more 6 characters",
              labelStyle: TextStyle(color: AppColor.blue),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignUpButton(SignUpBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context,enable,child) => NormalButton(
          title: "Sign Up",
          onPressed:
            enable ? (){
              bloc.event.add(
                  SignUpEvent(
                      displayName: _txtFullNameController.text,
                      phone: _txtPhoneController.text,
                      pass: _txtPassController.text,
                  ),
              );
          }       : null,
        ),
      ),
    );
  }

  handleEvent(BaseEvent baseEvent) {
    switch(baseEvent.runtimeType){
      case SignUpSuccessEvent:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          ModalRoute.withName('/home'),
        );
        break;
      case SignUpFailEvent:
        final snackBar = SnackBar(
          content: Text(baseEvent.errMessage),
          backgroundColor: AppColor.red,
        );
        Scaffold.of(context).showSnackBar(snackBar);
        break;
    }
  }
}

