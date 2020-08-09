import 'package:flutter/material.dart';
import 'package:flutterappbookstore/shared/app_color.dart';

class BtnCartAction extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  BtnCartAction({@required this.title,@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:42,
      height:42,
      child: RaisedButton(
        onPressed: onPressed,
        color: AppColor.white,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(7.0),
        ),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
