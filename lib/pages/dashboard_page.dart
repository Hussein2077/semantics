import 'package:flutter/material.dart';

import 'employee_page.dart';
import 'login_page.dart';
import '../widgets/testable_button.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const String routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    final String username =
        args is String && args.isNotEmpty ? args : 'user';

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Semantics(
          identifier: 'dashboard',
          container: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Semantics(
                identifier: 'dashboard_username',
                container: true,
                child: Text(
                  'Welcome $username',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 32),
              TestableButton(
                identifier: 'employee_open_button',
                label: 'Employees',
                onPressed: () =>
                    Navigator.of(context).pushNamed(EmployeePage.routeName),
              ),
              const SizedBox(height: 12),
              TestableButton(
                identifier: 'logout_button',
                label: 'Logout',
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil(LoginPage.routeName, (_) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
