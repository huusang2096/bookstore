
import 'package:flutter/material.dart';
import 'package:flutterappbookstore/data/spref/spref.dart';
import 'package:flutterappbookstore/shared/app_color.dart';
import 'package:flutterappbookstore/shared/constant.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startApp();
  }

  _startApp(){
    Future.delayed(Duration(seconds: 3),() async{
      var token = await SPref.instance.get(SPrefCache.KEY_TOKEN);
      if(token != null){
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }
      Navigator.pushReplacementNamed(context, '/sign-in');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/book.png',
              width: 200,
              height: 200,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'Book Store',
                style: TextStyle(
                  fontSize: 30,
                  color: AppColor.brown[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
