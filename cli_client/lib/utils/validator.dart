class Validator {
// check that nullable string is number
  static bool isNumber(String? value) {
    if (value == null) {
      return false;
    }
    final n = num.tryParse(value);
    return n != null;
  }

  static bool isString(String? value) {
    return value != null && value.isNotEmpty;
  }

  static bool isIndex(String? value, Iterable list) {
    if (!isNumber(value)) {
      return false;
    }
    final index = int.parse(value!);
    return index >= 1 && index < list.length + 1;
  }

  static bool isValidSocialSecurityNumber(String ssn) {
    // Проверяем, что строка состоит ровно из 12 цифр
    final RegExp ssnPattern = RegExp(r'^\d{12}$');

    // Возвращаем результат проверки по регулярному выражению
    return ssnPattern.hasMatch(ssn);
  }

  static bool isValidRegistrationNumber(String value) {
    // Add your validation logic here

    final regExp = RegExp(r'^[A-Z]{3}\d{3}$');

    return regExp.hasMatch(value);
  }
}
