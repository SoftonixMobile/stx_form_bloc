## 4.0.2
- Fix "isRequired" to check the overridable "requiredValidator" and "requiredBooleanValidator" instead of the default implementations
- Fix "changeRequirement" to add and remove the overridable "requiredValidator" and "requiredBooleanValidator" instead of the default implementations
- Rename "required" and "booleanRequired" validators to "defaultRequired" and "defaultBooleanRequired"

## 4.0.1
- Added "data" getter to FieldBloc
- Fix MultiFieldBloc validation

## 4.0.0
- Update dependencies

## 3.3.4
- Validate the date field when the first and last dates are changed

## 3.3.3
- Improve copyWith for flutter web

## 3.3.2
- Add methods to change firstDate and lastDate without field bloc
- Add additional methods to group field bloc
- Add tests

## 3.3.1
- Update dependencies

## 3.3.0
- Update dependencies

## 3.2.2
- Fixed validate in FieldBloc

## 3.2.1
- Fixed ordered behavior in MultiSelectFieldBloc

## 3.2.0
- Added "ordered" property to MultiSelectFieldBloc state.
- Made some methods public

## 3.1.5
- Added "readOnly" property to FieldBloc state.
- Added "data" property to FieldBloc state.
- Added missed setters

## 3.1.4
- Fix UpdateInitial

## 3.1.3
- Add "removeWhere" method to ListFieldBloc
- Add "forceValidation" parameter to the changeRequirement method

## 3.1.2
- Update dependencies

## 3.1.1
- Increase intl version to 1.8.0

## 3.1.0
- Dart 3 support

## 3.0.4
- Added statusStream to the FormBloc class

## 3.0.3
- Added loading field to the FieldBlocState class
- Added setters - value, loading, enabled, and required to the SingleFieldBloc class

## 3.0.2
- Added customSubmit field to the FormBloc class

## 3.0.1
- Made the error parameter optional in the emitFailure method

## 3.0.0
- Change data field to extraData
- Added ability set required validators
- Added InputFieldBloc
- Minor changes

## 2.0.5
- Keep loading status when change the fields.

## 2.0.4
- Added "disabled options" property to SelectFieldBlocState and MultiSelectFieldBlocState.

## 2.0.3
- Added "valueStream" to FieldBloc.
- Added "subscriptions" to FormBloc.

## 2.0.2
- Added "forceValueToSet" property in SelectFieldBloc and MultiSelectFieldBloc.


## 2.0.1
- Added clearRules and clearValidators method
- Revert deletion valueToInt and valueToDouble in TextFieldBloc
- Fixed cancellation

## 2.0.0
- Deleted emitLoading() in the submit method.
- Renamed "items" to "options" in SelectFieldBloc and MultiSelectFieldBloc.
- Added options getter to SelectFieldBloc and MultiSelectFieldBloc.
- Don't set value which isn't from the options.
- Added some getters to FormBloc.
- Added changeRequirement method.
- Changed type of the validators and rules properties to Set (instead of List).
- Add some useful method to FormBloc (addValidator, changeData, etc).
- Added DateFormat to DateTimeFieldBloc.
- Added toNullableString method to FormBloc.
- Changed TextFieldBloc initial value to "null".
- Fixed boolean validator.
- Added a couple of tests.

## 1.0.10+1
- Fixed "copyWith" method in ImageFieldBloc.

## 1.0.10
- Added ImageFieldBloc.
- Override "toString" method.

## 1.0.9+1
- Added "data" getter to FieldBloc.

## 1.0.9
- Added "data" field to FieldBlocState.

## 1.0.8+1
- Increased dart version.

## 1.0.8
- Fixed replaceWhere in ListFieldBloc.

## 1.0.7
- Fixed 'value' setter in ListFieldBloc.
- Added replaceAllWhere to ListFieldBloc.

## 1.0.6
- Fixed ListFieldBloc.
- Added 'value' setter to ListFieldBloc.
- Removed status listener in FormBloc (use GroupField instead).
- Minor improvements in FormBloc.
- Updated dependencies.

## 1.0.5
- Changed NumberFieldBloc's value type to int.

## 1.0.4
- Added NumberFieldBloc.
- Changed initialValue in BooleanFieldBloc to null.

## 1.0.3
- Added isRequired property to fieldBloc state.

## 1.0.2
- Added enabled and required properties.

## 1.0.1
- Updated dependencies.

## 1.0.0

- Initial version.
