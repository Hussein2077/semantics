/// A single employee record kept purely in memory (no backend, no database).
class Employee {
  Employee({
    required this.number,
    required this.name,
    required this.department,
    required this.email,
  });

  /// Business key of the employee, e.g. `EMP001`. Immutable so it can be used
  /// to build stable semantics identifiers for Selenium.
  final String number;

  String name;
  String department;
  String email;

  /// The stable semantics identifier of this employee's grid row.
  String get rowIdentifier => 'employee_row_$number';
}
