//email validation
bool validateEmail(String value){
  RegExp regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  if (value.isNotEmpty) {
    if (regex.hasMatch(value)) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

//password validation
bool validatePassword(String value){
  if (value.length > 8) {
      return true;
  } else {
    return false;
  }
}

bool validateText(String value){
  if (value.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}