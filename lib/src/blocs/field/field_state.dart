part of 'field_bloc.dart';

mixin FieldBlocStateBase {
  String get name;

  bool get isValid;

  bool get isNotValid => !isValid;

  dynamic get data;

  dynamic get extraData;

  FormBloc? get formBloc;

  bool get hasFormBloc => formBloc != null;
}

abstract class FieldBlocState<Value> extends Equatable with FieldBlocStateBase {
  FieldBlocState({
    required this.name,
    required this.initialValue,
    required this.value,
    required this.isValueChanged,
    required this.isDirty,
    required this.validators,
    required this.rules,
    required this.error,
    required this.enabled,
    required this.readOnly,
    required this.loading,
    required this.data,
    required this.extraData,
    required this.formBloc,
  });

  @override
  final String name;

  final Value initialValue;

  final Value value;

  final bool isValueChanged;

  final bool isDirty;

  final Set<Validator<Value>> validators;

  final Set<ValidationType> rules;

  final String? error;

  final bool enabled;

  final bool readOnly;

  final bool loading;

  @override
  final dynamic data;

  @override
  final dynamic extraData;

  @override
  final FormBloc? formBloc;

  @override
  bool get isValid => error == null;

  bool get isInitial => !isValueChanged;

  bool get hasValue =>
      value is List ? (value as List).isNotEmpty : value != null;

  bool get disabled => !enabled;

  bool get isRequired =>
      validators.contains(FieldBlocValidators.requiredValidator) ||
      validators.contains(FieldBlocValidators.requiredBooleanValidator);

  String? get displayError => isDirty ? error : null;

  FieldBlocState<Value> copyWith({
    Value? initialValue,
    Value? value,
    bool? isValueChanged,
    bool? isDirty,
    Set<Validator<Value>>? validators,
    Set<ValidationType>? rules,
    String? error,
    bool? enabled,
    bool? readOnly,
    bool? loading,
    dynamic data,
    dynamic extraData,
    FormBloc? formBloc,
  });

  @override
  List<Object?> get props => [
        initialValue,
        value,
        isValueChanged,
        isDirty,
        validators,
        rules,
        error,
        enabled,
        readOnly,
        loading,
        data,
        extraData,
        formBloc,
      ];

  String? toNullableString() {
    return value?.toString();
  }

  @override
  String toString() {
    return value?.toString() ?? '';
  }
}

abstract class MultiFieldBlocState extends Equatable with FieldBlocStateBase {
  @override
  final String name;

  @override
  final bool isValid;

  final bool hasDisplayError;

  @override
  final dynamic data;

  @override
  final dynamic extraData;

  @override
  final FormBloc? formBloc;

  Iterable<FieldBloc> get flatFieldBlocs;

  const MultiFieldBlocState({
    required this.name,
    required this.isValid,
    required this.hasDisplayError,
    required this.extraData,
    required this.data,
    required this.formBloc,
  });

  MultiFieldBlocState copyWith({
    bool? isValid,
    bool? hasDisplayError,
    dynamic data,
    dynamic extraData,
    FormBloc? formBloc,
  });

  @override
  List<Object?> get props => [
        name,
        isValid,
        hasDisplayError,
        extraData,
        formBloc,
      ];
}
