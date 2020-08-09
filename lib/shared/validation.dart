
class Validation{
  static isPhoneValid(String phone){
    final regexPhone = RegExp(r'^[0-9]+$');
    return regexPhone.hasMatch(phone) && phone.length>9;
  }

  static isPassValid(String pass){
    return pass.length >= 6;
  }

  static isEmailValid(String email){
    return email.length >= 6;
  }

  static isFullNameValid(String fullName){
    return fullName.length >=6;
  }

  static isPassNameValid(String pass,String fullName){
    return pass.length>=6 && fullName.length >=6;
  }
}