import 'package:stx_form_bloc/src/blocs/text_field/text_field_bloc.dart';

typedef Validator<Value> = String? Function(Value value);

enum ValidationType {
  onMounted,
  onChange,
  onBlur,
  onClear,
}

extension ValidationTypeX on Set<ValidationType>? {
  bool get hasOnMounted => this?.contains(ValidationType.onMounted) == true;
  bool get hasOnChange => this?.contains(ValidationType.onChange) == true;
  bool get hasOnBlur => this?.contains(ValidationType.onBlur) == true;
  bool get hasOnClear => this?.contains(ValidationType.onClear) == true;
}

class FieldBlocValidatorsErrors {
  FieldBlocValidatorsErrors._();

  static const _required = 'Field is required';

  static const _email = 'Email is invalid';

  static const _passwordMin6Chars =
      'Password length must be at least 6 characters';

  static const _confirmPassword = 'Confirm Password - Validator Error';
}

class FieldBlocValidators {
  FieldBlocValidators._();

  static Validator<dynamic> requiredValidator = defaultRequired;
  static Validator<bool?> requiredBooleanValidator = defaultBooleanRequired;

  static Set<Validator<T>> getValidators<T>(
      Set<Validator<T>>? validators, bool? required) {
    return {
      if (required == true) requiredValidator,
      ...?validators,
    };
  }

  static Set<Validator<bool?>> getBooleanValidators(
      Set<Validator<bool?>>? validators, bool? required) {
    return {
      if (required == true) requiredBooleanValidator,
      ...?validators,
    };
  }

  /// Check if the [value] is is not null, not empty.
  ///
  /// Returns `null` if is valid.
  ///
  /// Returns [FieldBlocValidatorsErrors.required]
  /// if is not valid.
  static String? defaultRequired(dynamic value) {
    if (value == null ||
        ((value is Iterable || value is String || value is Map) &&
            value.length == 0)) {
      return FieldBlocValidatorsErrors._required;
    }

    return null;
  }

  static String? defaultBooleanRequired(bool? value) {
    if (value == true) {
      return null;
    }

    return FieldBlocValidatorsErrors._required;
  }

  /// Check if the [string] is an email
  /// if [string] is not null and not empty.
  ///
  /// Returns `null` if is valid.
  ///
  /// Returns [FieldBlocValidatorsErrors.email]
  /// if is not valid.
  @Deprecated(
      'Use custom implementation of this validator. Will be removed in 4.0.0')
  static String? email(String? string) {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    if (string == null || string.isEmpty || emailRegExp.hasMatch(string)) {
      return null;
    }

    return FieldBlocValidatorsErrors._email;
  }

  /// Check if the [string] has min 6 chars
  /// if [string] is not null and not empty.
  ///
  /// Returns `null` if is valid.
  ///
  /// Returns [FieldBlocValidatorsErrors.passwordMin6Chars]
  /// if is not valid.
  @Deprecated(
      'Use custom implementation of this validator. Will be removed in 4.0.0')
  static String? passwordMin6Chars(String? string) {
    if (string == null || string.isEmpty || string.runes.length >= 6) {
      return null;
    }

    return FieldBlocValidatorsErrors._passwordMin6Chars;
  }

  /// Check if the `value` of the current [TextFieldBloc] is equals
  /// to [passwordTextFieldBloc.value].
  ///
  /// Returns a [Validator] `String Function(String string)`.
  ///
  /// This validator check if the `string` is equal to the current
  /// value of the [TextFieldBloc]
  /// if [string] is not null and not empty.
  ///
  /// Returns `null` if is valid.
  ///
  /// Returns [FieldBlocValidatorsErrors.email]
  /// if is not valid.
  ///
  /// Returns [FieldBlocValidatorsErrors.passwordMin6Chars]
  /// if is not valid.
  @Deprecated(
      'Use custom implementation of this validator. Will be removed in 4.0.0')
  static Validator<String?> confirmPassword(
    TextFieldBloc passwordTextFieldBloc,
  ) {
    return (String? confirmPassword) {
      if (confirmPassword == null ||
          confirmPassword.isEmpty ||
          confirmPassword == passwordTextFieldBloc.value) {
        return null;
      }
      return FieldBlocValidatorsErrors._confirmPassword;
    };
  }
}
