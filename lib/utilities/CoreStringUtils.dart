
class CoreStringUtils {

  static bool isEmpty(String str) {
    return str == null || str.length == 0;
  }

  static bool isNotEmpty(String str) => !isEmpty(str);

}