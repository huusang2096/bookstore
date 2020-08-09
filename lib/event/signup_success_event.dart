
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutterappbookstore/shared/model/user_data.dart';

class SignUpSuccessEvent extends BaseEvent{
  final UserData userData;
  SignUpSuccessEvent(this.userData);
}