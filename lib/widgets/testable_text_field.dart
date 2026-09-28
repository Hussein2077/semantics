import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// A Material text field bound to a reactive_forms [FormControl], wrapped in
/// a [Semantics] node carrying a stable [identifier].
///
/// Responsibilities stay separated:
///  * reactive_forms owns form state, validation and values;
///  * Semantics is only the accessibility / testability layer.
///
/// The validation message (when the control has errors and was touched) is
/// rendered below the field inside its own Semantics node identified as
/// `<identifier>_error`.
class TestableTextField extends StatefulWidget {
  const TestableTextField({
    super.key,
    required this.identifier,
    required this.formControl,
    required this.label,
    this.obscureText = false,
  });

  /// Stable test hook. On Flutter Web this ends up as the
  /// `flt-semantics-identifier` attribute of the semantics DOM element.
  final String identifier;

  final FormControl<String> formControl;
  final String label;
  final bool obscureText;

  @override
  State<TestableTextField> createState() => _TestableTextFieldState();
}

class _TestableTextFieldState extends State<TestableTextField> {
  StreamSubscription<bool>? _touchSub;
  StreamSubscription<String?>? _valueSub;
  StreamSubscription<ControlStatus>? _statusSub;

  @override
  void initState() {
    super.initState();
    // AbstractControl is stream based (not a Listenable), so subscribe to the
    // events that can change error visibility and rebuild this widget.
    _touchSub = widget.formControl.touchChanges.listen((_) => setState(() {}));
    _valueSub = widget.formControl.valueChanges.listen((_) => setState(() {}));
    _statusSub =
        widget.formControl.statusChanged.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    _touchSub?.cancel();
    _valueSub?.cancel();
    _statusSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FormControl<String> control = widget.formControl;
    final bool showErrors = control.hasErrors && control.touched;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Semantics(
          identifier: widget.identifier,
          child: ReactiveTextField<String>(
            formControl: control,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        if (showErrors)
          Semantics(
            identifier: '${widget.identifier}_error',
            container: true,
            child: Text(
              _errorText(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  String _errorText() {
    final Map<String, dynamic> errors = widget.formControl.errors;
    if (errors.containsKey(ValidationMessage.required)) {
      return '${widget.label} is required';
    }
    if (errors.containsKey(ValidationMessage.minLength)) {
      final int requiredLength =
          errors[ValidationMessage.minLength]['requiredLength'] as int;
      return '${widget.label} must be at least $requiredLength characters';
    }
    if (errors.containsKey(ValidationMessage.email)) {
      return 'Enter a valid ${widget.label.toLowerCase()}';
    }
    return 'Invalid value';
  }
}
