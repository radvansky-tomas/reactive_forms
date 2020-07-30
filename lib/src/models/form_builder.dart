import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_forms/src/exceptions/form_builder_invalid_initialization_exception.dart';

class FormBuilder {
  const FormBuilder();

  FormGroup group(Map<String, dynamic> controls) {
    final map = controls.map((key, value) {
      if (value is String) {
        return MapEntry(key, FormControl<String>(defaultValue: value));
      } else if (value is int) {
        return MapEntry(key, FormControl<int>(defaultValue: value));
      } else if (value is bool) {
        return MapEntry(key, FormControl<bool>(defaultValue: value));
      } else if (value is double) {
        return MapEntry(key, FormControl<double>(defaultValue: value));
      } else if (value is AbstractControl) {
        return MapEntry(key, value);
      } else if (value is ValidatorFunction) {
        return MapEntry(key, FormControl(validators: [value]));
      } else if (value is Iterable<ValidatorFunction>) {
        return MapEntry(key, FormControl(validators: value));
      } else if (value is Iterable<dynamic>) {
        if (value.isEmpty) {
          return MapEntry(key, FormControl());
        } else {
          final defaultValue = value.first;
          final validators = List.of(value
              .skip(1)
              .map<ValidatorFunction>((v) => v as ValidatorFunction));

          if (validators.isNotEmpty &&
              validators.any((validator) => validator == null)) {
            throw FormBuilderInvalidInitializationException(
                'Invalid validators initialization');
          }

          if (defaultValue is ValidatorFunction) {
            throw FormBuilderInvalidInitializationException(
                'Expected first value in array to be default value of the control and not a validator.');
          }

          final control = _control(defaultValue, validators);
          return MapEntry(key, control);
        }
      }

      return MapEntry(key, FormControl(defaultValue: value));
    });

    return FormGroup(map);
  }

  FormControl _control(dynamic value, List<ValidatorFunction> validators) {
    if (value is AbstractControl) {
      throw FormBuilderInvalidInitializationException(
          'Default value of control must not be an AbstractControl.');
    }

    if (value is String) {
      return FormControl<String>(defaultValue: value, validators: validators);
    } else if (value is int) {
      return FormControl<int>(defaultValue: value, validators: validators);
    } else if (value is bool) {
      return FormControl<bool>(defaultValue: value, validators: validators);
    } else if (value is double) {
      return FormControl<double>(defaultValue: value, validators: validators);
    }

    return FormControl(defaultValue: value, validators: validators);
  }
}

const fb = const FormBuilder();
