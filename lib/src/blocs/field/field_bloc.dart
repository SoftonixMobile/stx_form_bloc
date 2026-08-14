import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stx_form_bloc/src/blocs/form_bloc/form_bloc.dart';
import 'package:stx_form_bloc/src/validators/field_bloc_validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

part 'field_bloc_utils.dart';
part 'field_state.dart';

mixin FieldBloc<State extends FieldBlocStateBase> on BlocBase<State> {
  String get name => state.name;

  dynamic get data => state.data;

  dynamic get extraData => state.extraData;

  bool validate();

  void reset();

  void clear();

  void updateFormBloc(FormBloc formBloc);

  void removeFormBloc(FormBloc formBloc);
}

abstract class SingleFieldBloc<Value, State extends FieldBlocState<Value>>
    extends Cubit<State> with FieldBloc {
  SingleFieldBloc({
    required State initialState,
    required this.defaultValue,
  }) : super(initialState);

  final Value defaultValue;

  late Stream<Value> valueStream = stream
      .transform<Value>(
        StreamTransformer.fromHandlers(
          handleData: (state, sink) => sink.add(state.value),
        ),
      )
      .distinct();

  Value get value => state.value;
  Value get initialValue => state.initialValue;

  bool get isInitial => state.isInitial;
  bool get isValueChanged => state.isValueChanged;

  Set<Validator<Value>> get validators => state.validators;
  bool get isRequired => state.isRequired;

  Set<ValidationType> get rules => state.rules;

  bool get enabled => state.enabled;
  bool get disabled => state.disabled;

  bool get readOnly => state.readOnly;

  bool get isLoading => state.loading;

  bool get isValid => state.isValid;
  bool get isNotValid => state.isNotValid;

  String? get error => state.error;
  String? get displayError => state.displayError;

  set value(Value value) {
    changeValue(value);
  }

  set required(bool required) {
    changeRequirement(required);
  }

  set enabled(bool enabled) {
    changeAvailability(enabled);
  }

  set readOnly(bool readOnly) {
    changeReadOnly(readOnly);
  }

  set loading(bool loading) {
    changeLoading(loading);
  }

  set data(dynamic data) {
    changeData(data);
  }

  set extraData(dynamic extraData) {
    changeExtraData(extraData);
  }

  String? getError(Value value, {Set<String? Function(Value)>? newValidators}) {
    String? error;

    for (var validator in newValidators ?? validators) {
      error = validator(value);
      if (error != null) return error;
    }

    return error;
  }

  @override
  bool validate() {
    final error = getError(state.value);

    emit(
      state.copyWith(
        error: error,
        isDirty: true,
      ) as State,
    );

    return isValid;
  }

  void updateInitial(Value value, {bool forceChange = false}) {
    if (!forceChange && disabled) return;

    final error = getError(value);

    emit(state.copyWith(
      initialValue: value,
      value: value,
      isValueChanged: false,
      error: error,
      isDirty: rules.hasOnMounted,
    ) as State);
  }

  void changeValue(Value value, {bool forceChange = false}) {
    if (!forceChange && (disabled || readOnly)) return;

    final error = getError(value);

    emit(state.copyWith(
      value: value,
      error: error,
      isValueChanged: true,
      isDirty: rules.hasOnChange,
    ) as State);
  }

  @override
  void clear({bool force = false}) {
    if (!force && (disabled || readOnly)) return;

    final error = getError(defaultValue);

    emit(state.copyWith(
      value: defaultValue,
      error: error,
      isValueChanged: true,
      isDirty: rules.hasOnChange || rules.hasOnClear,
    ) as State);
  }

  @override
  void reset({bool force = false}) {
    if (!force && (disabled && readOnly)) return;

    final value = state.initialValue;
    final error = getError(value);

    emit(state.copyWith(
      value: value,
      isValueChanged: false,
      error: error,
      isDirty: rules.hasOnMounted,
    ) as State);
  }

  void focusChanged() {
    emit(state.copyWith(
      isDirty: rules.hasOnBlur,
    ) as State);
  }

  void addValidator(
    Validator<Value> validator, {
    bool forceValidation = false,
  }) =>
      addValidators({validator}, forceValidation: forceValidation);

  void addValidators(
    Set<Validator<Value>> validators, {
    bool forceValidation = false,
  }) {
    final updatedValidators = {...this.validators, ...validators};

    changeValidators(updatedValidators, forceValidation: forceValidation);
  }

  void changeValidators(
    Set<Validator<Value>> validators, {
    bool forceValidation = false,
  }) {
    final error = getError(state.value, newValidators: validators);

    emit(
      state.copyWith(
        validators: validators,
        error: error,
        isDirty: forceValidation,
      ) as State,
    );
  }

  void removeValidator(
    Validator<Value> validator, {
    bool forceValidation = false,
  }) =>
      removeValidators({validator}, forceValidation: forceValidation);

  void removeValidators(
    Set<Validator<Value>> validators, {
    bool forceValidation = false,
  }) {
    final updatedValidators = {...this.validators}..removeAll(validators);

    changeValidators(updatedValidators, forceValidation: forceValidation);
  }

  void clearValidators() => changeValidators({});

  void changeRequirement(bool required, {bool forceValidation = false}) {
    if (isRequired == required) return;

    if (required) {
      addValidator(
        FieldBlocValidators.requiredValidator,
        forceValidation: forceValidation,
      );
    } else {
      removeValidator(
        FieldBlocValidators.requiredValidator,
        forceValidation: forceValidation,
      );
    }
  }

  void addRule(ValidationType rule) => addRules({rule});
  void addRules(Set<ValidationType> rules) {
    final updatedRules = {...this.rules, ...rules};

    changeRules(updatedRules);
  }

  void changeRules(Set<ValidationType> rules) {
    emit(state.copyWith(
      rules: rules,
      isDirty: rules.hasOnMounted,
    ) as State);
  }

  void removeRule(ValidationType rule) => removeRules({rule});
  void removeRules(Set<ValidationType> rules) {
    final updatedRules = {...this.rules}..removeAll(rules);

    changeRules(updatedRules);
  }

  void clearRules() => changeRules({});

  /// It is useful when you want to add errors that
  /// you have obtained when submitting the `FormBloc`.
  void addFieldError(String error, {bool? isDirty}) {
    emit(state.copyWith(
      error: error,
      isDirty: isDirty,
    ) as State);
  }

  void changeAvailability(bool enabled) {
    emit(state.copyWith(enabled: enabled) as State);
  }

  void changeReadOnly(bool readOnly) {
    emit(state.copyWith(readOnly: readOnly) as State);
  }

  void changeLoading(bool loading) {
    emit(state.copyWith(loading: loading) as State);
  }

  void changeData(dynamic data) {
    emit(state.copyWith(data: data) as State);
  }

  void changeExtraData(dynamic extraData) {
    emit(state.copyWith(extraData: extraData) as State);
  }

  @override
  void updateFormBloc(FormBloc formBloc) {
    emit(state.copyWith(
      formBloc: formBloc,
    ) as State);
  }

  @override
  void removeFormBloc(FormBloc formBloc) {
    if (state.formBloc == formBloc) {
      emit(state.copyWith(formBloc: null) as State);
    }
  }

  String? toNullableString() {
    return state.toNullableString();
  }

  @override
  String toString() {
    return state.toString();
  }
}

class MultiFieldBloc<TState extends MultiFieldBlocState> extends Cubit<TState>
    with FieldBloc<TState> {
  late final StreamSubscription _onValidationStatus;

  MultiFieldBloc(super.initialState) {
    _onValidationStatus = stream.switchMap((state) {
      return MultiFieldBloc.onValidationStatus(state.flatFieldBlocs);
    }).listen((isValid) {
      emit(state.copyWith(
        isValid: isValid,
        hasDisplayError: deepHasDisplayError(flatFieldBlocs),
      ) as TState);
    });
  }

  Iterable<FieldBloc> get flatFieldBlocs => state.flatFieldBlocs;

  bool get isValuesChanged => FormBlocUtils.isValuesChanged(flatFieldBlocs);

  bool get isInitial => FormBlocUtils.hasInitialValues(flatFieldBlocs);

  bool get hasDisplayError => state.hasDisplayError;

  bool get isValid => state.isValid;

  @override
  void reset() {
    for (var f in flatFieldBlocs) {
      f.reset();
    }
  }

  @override
  void clear() {
    for (var f in flatFieldBlocs) {
      f.clear();
    }
  }

  @override
  bool validate() {
    final isValid = validateAll(state.flatFieldBlocs);

    emit(state.copyWith(
      isValid: isValid,
      hasDisplayError: deepHasDisplayError(flatFieldBlocs),
    ) as TState);

    return isValid;
  }

  @override
  void updateFormBloc(FormBloc formBloc) {
    emit(state.copyWith(
      formBloc: formBloc,
    ) as TState);

    FormBlocUtils.updateFormBloc(
      fieldBlocs: state.flatFieldBlocs,
      formBloc: formBloc,
    );
  }

  @override
  void removeFormBloc(FormBloc formBloc) {
    if (state.formBloc == formBloc) {
      emit(state.copyWith(
        formBloc: null,
      ) as TState);

      FormBlocUtils.removeFormBloc(
        fieldBlocs: state.flatFieldBlocs,
        formBloc: formBloc,
      );
    }
  }

  @override
  Future<void> close() {
    _onValidationStatus.cancel();
    for (final fieldBloc in state.flatFieldBlocs) {
      fieldBloc.close();
    }
    return super.close();
  }

  static Stream<bool> onValidationStatus(
    Iterable<FieldBloc> fieldBlocs,
  ) {
    return Rx.combineLatestList(fieldBlocs.map((fieldBloc) {
      return Rx.merge([Stream.value(fieldBloc.state), fieldBloc.stream]);
    })).map((fieldStates) {
      return fieldStates.every((fieldState) => fieldState.isValid);
    }).distinct();
  }

  static bool validateAll(Iterable<FieldBloc> fieldBlocs) {
    for (var field in fieldBlocs) {
      field.validate();
    }

    return fieldBlocs.every((field) => field.state.isValid);
  }

  static bool deepContains(Iterable<FieldBloc> fieldBlocs, FieldBloc target) {
    if (fieldBlocs.isEmpty) return false;

    for (final fieldBloc in fieldBlocs) {
      if (fieldBloc is MultiFieldBloc) {
        final contains =
            MultiFieldBloc.deepContains(fieldBloc.state.flatFieldBlocs, target);
        if (contains) {
          return true;
        }
      } else if (fieldBloc.state.name == target.state.name) {
        return true;
      }
    }
    return false;
  }

  static bool deepHasDisplayError(Iterable<FieldBloc> fieldBlocs) {
    if (fieldBlocs.isEmpty) return false;

    for (final fieldBloc in fieldBlocs) {
      if (fieldBloc is MultiFieldBloc) {
        final contains =
            MultiFieldBloc.deepHasDisplayError(fieldBloc.state.flatFieldBlocs);
        if (contains) {
          return true;
        }
      } else if (fieldBloc is SingleFieldBloc) {
        if (fieldBloc.state.displayError != null) {
          return true;
        }
      }
    }
    return false;
  }
}
