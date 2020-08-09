abstract class BaseEvent{
  String get errMessage => null;

  String type(){
    return this.runtimeType.toString();
  }
}