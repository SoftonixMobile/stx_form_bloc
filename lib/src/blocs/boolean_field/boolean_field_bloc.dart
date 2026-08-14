import 'package:stx_form_bloc/src/blocs/field/field_bloc.dart';
import 'package:stx_form_bloc/src/blocs/form_bloc/form_bloc.dart';
import 'package:stx_form_bloc/src/validators/field_bloc_validators.dart';

part 'boolean_field_state.dart';

class BooleanFieldBloc extends SingleFieldBloc<bool?, BooleanFieldBlocState> {
  BooleanFieldBloc({
    String? name,
    bool? initialValue,
    bool enabled = true,
    bool readOnly = false,
    bool loading = false,
    bool? required,
    Set<Validator<bool?>>? customValidators,
    Set<ValidationType> rules = const {},
    dynamic data,
    dynamic extraData,
  }) : super(
          initialState: BooleanFieldBlocState(
            name: FieldBlocUtils.generateName(name),
            initialValue: initialValue,
            value: initialValue,
            isValueChanged: false,
            isDirty: rules.hasOnMounted,
            validators: FieldBlocValidators.getBooleanValidators(
              customValidators,
              required,
            ),
            rules: rules,
            error: FieldBlocUtils.getInitialStateError(
              value: initialValue,
              validators: FieldBlocValidators.getBooleanValidators(
                customValidators,
                required,
              ),
            ),
            enabled: enabled,
            readOnly: readOnly,
            loading: loading,
            data: data,
            extraData: extraData,
          ),
          defaultValue: null,
        );

  @override
  void changeRequirement(bool required, {bool forceValidation = false}) {
    if (isRequired == required) return;

    if (required) {
      addValidator(
        FieldBlocValidators.defaultBooleanRequired,
        forceValidation: forceValidation,
      );
    } else {
      removeValidator(
        FieldBlocValidators.defaultBooleanRequired,
        forceValidation: forceValidation,
      );
    }
  }
}
