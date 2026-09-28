import '../models/employee.dart';

/// In-memory employee store. No backend, no database.
class EmployeeService {
  final List<Employee> _employees = <Employee>[];

  List<Employee> get employees => List<Employee>.unmodifiable(_employees);

  void add(Employee employee) => _employees.add(employee);

  void delete(Employee employee) => _employees.remove(employee);

  /// Case-insensitive filter on employee number or name. An empty query
  /// returns every employee.
  List<Employee> search(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return employees;
    }
    return _employees
        .where(
          (Employee e) =>
              e.number.toLowerCase().contains(q) ||
              e.name.toLowerCase().contains(q),
        )
        .toList();
  }
}
