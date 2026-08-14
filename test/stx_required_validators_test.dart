import 'package:stx_form_bloc/stx_form_bloc.dart';
import 'package:test/test.dart';

const defaultRequiredError = 'Field is required';
const customRequiredError = 'Custom required error';
const customBooleanRequiredError = 'Custom boolean required error';

String? customRequired(dynamic value) {
  return FieldBlocValidators.defaultRequired(value) == null
      ? null
      : customRequiredError;
}

String? customBooleanRequired(bool? value) {
  return value == true ? null : customBooleanRequiredError;
}

void main() {
  final originalRequired = FieldBlocValidators.requiredValidator;
  final originalBooleanRequired = FieldBlocValidators.requiredBooleanValidator;

  tearDown(() {
    FieldBlocValidators.requiredValidator = originalRequired;
    FieldBlocValidators.requiredBooleanValidator = originalBooleanRequired;
  });

  group("Default required validators", () {
    test("Overridable validators point to the default implementations", () {
      expect(
        FieldBlocValidators.requiredValidator,
        equals(FieldBlocValidators.defaultRequired),
      );
      expect(
        FieldBlocValidators.requiredBooleanValidator,
        equals(FieldBlocValidators.defaultBooleanRequired),
      );
    });

    test("defaultRequired", () {
      expect(FieldBlocValidators.defaultRequired(null), defaultRequiredError);
      expect(FieldBlocValidators.defaultRequired(''), defaultRequiredError);
      expect(FieldBlocValidators.defaultRequired([]), defaultRequiredError);
      expect(FieldBlocValidators.defaultRequired(<String, int>{}),
          defaultRequiredError);

      expect(FieldBlocValidators.defaultRequired('Test'), isNull);
      expect(FieldBlocValidators.defaultRequired(0), isNull);
      expect(FieldBlocValidators.defaultRequired(false), isNull);
      expect(FieldBlocValidators.defaultRequired([1]), isNull);
      expect(FieldBlocValidators.defaultRequired({'a': 1}), isNull);
    });

    test("defaultBooleanRequired", () {
      expect(FieldBlocValidators.defaultBooleanRequired(null),
          defaultRequiredError);
      expect(FieldBlocValidators.defaultBooleanRequired(false),
          defaultRequiredError);

      expect(FieldBlocValidators.defaultBooleanRequired(true), isNull);
    });
  });

  group("getValidators / getBooleanValidators", () {
    test("Add the required validator only when required is true", () {
      expect(FieldBlocValidators.getValidators<dynamic>(null, null), isEmpty);
      expect(FieldBlocValidators.getValidators<dynamic>(null, false), isEmpty);
      expect(
        FieldBlocValidators.getValidators<dynamic>(null, true),
        {FieldBlocValidators.requiredValidator},
      );

      expect(
          FieldBlocValidators.getBooleanValidators(null, null), isEmpty);
      expect(
          FieldBlocValidators.getBooleanValidators(null, false), isEmpty);
      expect(
        FieldBlocValidators.getBooleanValidators(null, true),
        {FieldBlocValidators.requiredBooleanValidator},
      );
    });

    test("Use the overridden validators", () {
      FieldBlocValidators.requiredValidator = customRequired;
      FieldBlocValidators.requiredBooleanValidator = customBooleanRequired;

      expect(
        FieldBlocValidators.getValidators<dynamic>(null, true),
        {customRequired},
      );
      expect(
        FieldBlocValidators.getBooleanValidators(null, true),
        {customBooleanRequired},
      );
    });

    test("Keep the custom validators", () {
      String? customValidator(dynamic value) => null;

      expect(
        FieldBlocValidators.getValidators<dynamic>({customValidator}, true),
        {FieldBlocValidators.requiredValidator, customValidator},
      );
      expect(
        FieldBlocValidators.getValidators<dynamic>({customValidator}, false),
        {customValidator},
      );
    });
  });

  group("isRequired with the default validators", () {
    test("Single field blocs", () {
      expect(TextFieldBloc(required: true).state.isRequired, isTrue);
      expect(TextFieldBloc(required: false).state.isRequired, isFalse);
      expect(TextFieldBloc().state.isRequired, isFalse);

      expect(BooleanFieldBloc(required: true).state.isRequired, isTrue);
      expect(BooleanFieldBloc(required: false).state.isRequired, isFalse);
      expect(BooleanFieldBloc().state.isRequired, isFalse);
    });

    test("A custom validator does not make the field required", () {
      String? customValidator(String? value) => null;

      final textField = TextFieldBloc(customValidators: {customValidator});

      expect(textField.state.validators, {customValidator});
      expect(textField.state.isRequired, isFalse);
    });
  });

  group("isRequired with the overridden validators", () {
    test("SingleFieldBloc created as required", () {
      FieldBlocValidators.requiredValidator = customRequired;

      final textField = TextFieldBloc(required: true);

      expect(textField.state.validators, {customRequired});
      expect(textField.state.isRequired, isTrue);
      expect(textField.state.error, customRequiredError);
    });

    test("SingleFieldBloc created as not required", () {
      FieldBlocValidators.requiredValidator = customRequired;

      final textField = TextFieldBloc(required: false);

      expect(textField.state.validators, isEmpty);
      expect(textField.state.isRequired, isFalse);
      expect(textField.state.error, isNull);
    });

    test("BooleanFieldBloc created as required", () {
      FieldBlocValidators.requiredBooleanValidator = customBooleanRequired;

      final booleanField = BooleanFieldBloc(required: true);

      expect(booleanField.state.validators, {customBooleanRequired});
      expect(booleanField.state.isRequired, isTrue);
      expect(booleanField.state.error, customBooleanRequiredError);
    });

    test("BooleanFieldBloc created as not required", () {
      FieldBlocValidators.requiredBooleanValidator = customBooleanRequired;

      final booleanField = BooleanFieldBloc(required: false);

      expect(booleanField.state.validators, isEmpty);
      expect(booleanField.state.isRequired, isFalse);
      expect(booleanField.state.error, isNull);
    });

    test("All single field blocs created as required", () {
      FieldBlocValidators.requiredValidator = customRequired;
      FieldBlocValidators.requiredBooleanValidator = customBooleanRequired;

      final allFields = <SingleFieldBloc>[
        TextFieldBloc(required: true),
        NumberFieldBloc(required: true),
        DateTimeFieldBloc(required: true),
        ListFieldBloc(required: true),
        SelectFieldBloc(required: true),
        MultiSelectFieldBloc(required: true),
        ImageFieldBloc(required: true),
        BooleanFieldBloc(required: true),
      ];

      for (var field in allFields) {
        expect(field.state.isRequired, isTrue);
        expect(field.state.isNotValid, isTrue);
      }
    });
  });

  group("changeRequirement with the overridden validators", () {
    test("Remove the overridden required validator", () {
      FieldBlocValidators.requiredValidator = customRequired;

      final textField = TextFieldBloc(required: true);

      textField.required = false;

      expect(textField.state.validators, isEmpty);
      expect(textField.state.isRequired, isFalse);
      expect(textField.state.error, isNull);
      expect(textField.state.isValid, isTrue);
    });

    test("Add the overridden required validator", () {
      FieldBlocValidators.requiredValidator = customRequired;

      final textField = TextFieldBloc();

      textField.required = true;

      expect(textField.state.validators, {customRequired});
      expect(textField.state.isRequired, isTrue);
      expect(textField.state.error, customRequiredError);
    });

    test("Remove the overridden boolean required validator", () {
      FieldBlocValidators.requiredBooleanValidator = customBooleanRequired;

      final booleanField = BooleanFieldBloc(required: true);

      booleanField.required = false;

      expect(booleanField.state.validators, isEmpty);
      expect(booleanField.state.isRequired, isFalse);
      expect(booleanField.state.error, isNull);
      expect(booleanField.state.isValid, isTrue);
    });

    test("Add the overridden boolean required validator", () {
      FieldBlocValidators.requiredBooleanValidator = customBooleanRequired;

      final booleanField = BooleanFieldBloc();

      booleanField.required = true;

      expect(booleanField.state.validators, {customBooleanRequired});
      expect(booleanField.state.isRequired, isTrue);
      expect(booleanField.state.error, customBooleanRequiredError);
    });

    test("Keep the custom validators when the requirement changes", () {
      FieldBlocValidators.requiredValidator = customRequired;

      String? customValidator(String? value) => null;

      final textField = TextFieldBloc(
        required: true,
        customValidators: {customValidator},
      );

      expect(textField.state.validators, {customRequired, customValidator});

      textField.required = false;

      expect(textField.state.validators, {customValidator});
      expect(textField.state.isRequired, isFalse);

      textField.required = true;

      expect(textField.state.validators, {customValidator, customRequired});
      expect(textField.state.isRequired, isTrue);
    });

    test("Changing to the same requirement does not emit a new state", () {
      FieldBlocValidators.requiredValidator = customRequired;

      final textField = TextFieldBloc(required: true);
      final state = textField.state;

      textField.required = true;

      expect(textField.state, same(state));
      expect(textField.state.isRequired, isTrue);
    });

    test("forceValidation makes the error visible", () {
      FieldBlocValidators.requiredValidator = customRequired;

      final textField = TextFieldBloc();

      textField.changeRequirement(true, forceValidation: true);

      expect(textField.state.isRequired, isTrue);
      expect(textField.state.displayError, customRequiredError);
    });
  });
}
