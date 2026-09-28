import 'package:flutter/material.dart';

import 'pages/dashboard_page.dart';
import 'pages/employee_page.dart';
import 'pages/login_page.dart';

/// Root widget: routes only, no global state needed for this demo.
class SemanticsApp extends StatelessWidget {
  const SemanticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Semantics + Selenium Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        DashboardPage.routeName: (_) => const DashboardPage(),
        EmployeePage.routeName: (_) => const EmployeePage(),
      },
    );
  }
}
