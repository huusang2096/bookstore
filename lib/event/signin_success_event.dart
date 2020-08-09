
import 'package:flutterappbookstore/base/base_event.dart';
import 'package:flutterappbookstore/shared/model/user_data.dart';

class SignInSuccessEvent extends BaseEvent{
  final UserData userData;
  SignInSuccessEvent(this.userData);
}