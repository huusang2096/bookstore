import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterappbookstore/base/base_bloc.dart';
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:provider/provider.dart';

class BlocListener<T extends BaseBloc> extends StatefulWidget {
  final Widget child;
  final Function(BaseEvent event) listener;

  BlocListener({@required this.child,@required this.listener});

  @override
  _BlocListener createState() => _BlocListener<T>();
}

class _BlocListener<T> extends State<BlocListener> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    var bloc = Provider.of<T>(context) as BaseBloc;
    bloc.processEventStream.listen((event) {
      widget.listener(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<BaseEvent>.value(
      initialData: null,
      value: (Provider.of<T>(context) as BaseBloc).processEventStream,
      updateShouldNotify: (prev,cur){
        return false;
      },
      child: Consumer<BaseEvent>(
        builder: (context, event, child) => Container(
          child: widget.child,
        ),
      ),
    );
  }

}
