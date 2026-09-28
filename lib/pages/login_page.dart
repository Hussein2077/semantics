import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../services/auth_service.dart';
import '../widgets/testable_button.dart';
import '../widgets/testable_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FormControl<String> _username =
      FormControl<String>(validators: <Validator<dynamic>>[Validators.required]);

  final FormControl<String> _password = FormControl<String>(
    validators: <Validator<dynamic>>[
      Validators.required,
      Validators.minLength(6),
    ],
  );

  late final FormGroup _form = FormGroup(<String, AbstractControl<Object?>>{
    'username': _username,
    'password': _password,
  });

  final AuthService _authService = AuthService();

  bool _submitting = false;
  String? _loginError;

  Future<void> _login() async {
    setState(() => _loginError = null);

    if (_form.invalid) {
      _form.markAllAsTouched();
      return;
    }

    setState(() => _submitting = true);

    // Simulate an API call; no backend, no database.
    final bool ok = await _authService.login(
      _username.value ?? '',
      _password.value ?? '',
    );

    if (!mounted) {
      return;
    }

    if (ok) {
      Navigator.of(context).pushReplacementNamed(
        '/dashboard',
        arguments: _username.value,
      );
    } else {
      setState(() {
        _submitting = false;
        _loginError = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SizedBox(
          width: 360,
          child: ReactiveForm(
            formGroup: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TestableTextField(
                  identifier: 'login_username',
                  formControl: _username,
                  label: 'Username',
                ),
                const SizedBox(height: 16),
                TestableTextField(
                  identifier: 'login_password',
                  formControl: _password,
                  label: 'Password',
                  obscureText: true,
                ),
                if (_loginError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Semantics(
                      identifier: 'login_error',
                      container: true,
                      child: Text(
                        _loginError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Center(
                  child: TestableButton(
                    identifier: 'login_button',
                    label: 'Login',
                    onPressed: _submitting ? null : _login,
                  ),
                ),
                if (_submitting)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
