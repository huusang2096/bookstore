import 'package:flutter/cupertino.dart';
import 'package:flutterappbookstore/base/base_event.dart';

class ShouldRebuildEvent extends BaseEvent{
  BuildContext context;

  ShouldRebuildEvent(this.context);
}