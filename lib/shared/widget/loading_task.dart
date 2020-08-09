import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterappbookstore/base/base_bloc.dart';
import 'package:flutterappbookstore/shared/app_color.dart';
import 'package:provider/provider.dart';

class LoadingTask extends StatelessWidget {
  final Widget child;
  final BaseBloc bloc;

  LoadingTask({@required this.child,@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.loadingStream,
      child: Stack(
        children: <Widget>[
          child,
          Consumer<bool>(
            builder: (context, isLoading, child) => Center(
              child: isLoading
              ? AnimatedContainer(
                duration: Duration(seconds: 2),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: new BoxDecoration(
                    color: AppColor.black,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: SpinKitFadingCube(
                    color: AppColor.red,
                  ),
                ),
              )
              : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
