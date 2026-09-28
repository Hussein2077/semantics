import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/employee.dart';
import '../services/employee_service.dart';
import '../widgets/testable_button.dart';
import '../widgets/testable_text_field.dart';

/// Employee screen with a CRUD-like in-memory UI:
/// add / save (create or update) / cancel / delete / search / grid.
class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  static const String routeName = '/employee';

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final EmployeeService _service = EmployeeService();

  final FormControl<String> _number =
      FormControl<String>(validators: <Validator<dynamic>>[Validators.required]);
  final FormControl<String> _name =
      FormControl<String>(validators: <Validator<dynamic>>[Validators.required]);
  final FormControl<String> _department =
      FormControl<String>(validators: <Validator<dynamic>>[Validators.required]);
  final FormControl<String> _email = FormControl<String>(
    validators: <Validator<dynamic>>[
      Validators.required,
      Validators.email,
    ],
  );
  final FormControl<String> _search = FormControl<String>();

  late final FormGroup _form = FormGroup(<String, AbstractControl<Object?>>{
    'employee_number': _number,
    'employee_name': _name,
    'employee_department': _department,
    'employee_email': _email,
  });

  StreamSubscription<String?>? _searchSub;

  Employee? _selected;
  String? _successMessage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Live search: rebuild the grid whenever the search value changes.
    _searchSub = _search.valueChanges.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    _searchSub?.cancel();
    super.dispose();
  }

  List<Employee> get _filteredEmployees => _service.search(_search.value ?? '');

  void _clearStatus() {
    _successMessage = null;
    _errorMessage = null;
  }

  /// Prepare the form for a new employee (clears form, selection, status).
  void _add() {
    setState(() {
      _selected = null;
      _form.reset();
      _clearStatus();
    });
  }

  void _save() {
    setState(_clearStatus);

    if (_form.invalid) {
      _form.markAllAsTouched();
      setState(() => _errorMessage = 'Form contains validation errors');
      return;
    }

    final Employee employee = Employee(
      number: _number.value!.trim(),
      name: _name.value!.trim(),
      department: _department.value!.trim(),
      email: _email.value!.trim(),
    );

    setState(() {
      if (_selected != null) {
        _selected!.name = employee.name;
        _selected!.department = employee.department;
        _selected!.email = employee.email;
        _successMessage = 'Employee ${employee.number} updated';
      } else {
        _service.add(employee);
        _successMessage = 'Employee ${employee.number} saved';
      }
      _selected = null;
      _form.reset();
    });
  }

  void _delete() {
    final Employee? selected = _selected;
    if (selected == null) {
      setState(() => _errorMessage = 'Select an employee to delete');
      return;
    }
    setState(() {
      _service.delete(selected);
      _successMessage = 'Employee ${selected.number} deleted';
      _selected = null;
      _form.reset();
      _errorMessage = null;
    });
  }

  void _selectEmployee(Employee employee) {
    setState(() {
      _selected = employee;
      _number.value = employee.number;
      _name.value = employee.name;
      _department.value = employee.department;
      _email.value = employee.email;
      _clearStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ------------------------------------------------ form panel
            Expanded(
              flex: 2,
              child: ReactiveForm(
                formGroup: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TestableTextField(
                      identifier: 'employee_number',
                      formControl: _number,
                      label: 'Employee Number',
                    ),
                    const SizedBox(height: 16),
                    TestableTextField(
                      identifier: 'employee_name',
                      formControl: _name,
                      label: 'Employee Name',
                    ),
                    const SizedBox(height: 16),
                    TestableTextField(
                      identifier: 'employee_department',
                      formControl: _department,
                      label: 'Department',
                    ),
                    const SizedBox(height: 16),
                    TestableTextField(
                      identifier: 'employee_email',
                      formControl: _email,
                      label: 'Email',
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        TestableButton(
                          identifier: 'employee_add_button',
                          label: 'Add',
                          onPressed: _add,
                        ),
                        TestableButton(
                          identifier: 'employee_save_button',
                          label: 'Save',
                          onPressed: _save,
                        ),
                        TestableButton(
                          identifier: 'employee_cancel_button',
                          label: 'Cancel',
                          onPressed: _add,
                        ),
                        TestableButton(
                          identifier: 'employee_delete_button',
                          label: 'Delete',
                          onPressed: _delete,
                        ),
                      ],
                    ),
                    if (_successMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Semantics(
                          identifier: 'success_message',
                          container: true,
                          child: Text(
                            _successMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Semantics(
                          identifier: 'error_message',
                          container: true,
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 32),
            // ------------------------------------------------ list panel
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TestableTextField(
                    identifier: 'employee_search',
                    formControl: _search,
                    label: 'Search by number or name',
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    identifier: 'employee_grid',
                    container: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _headerRow(),
                        ..._filteredEmployees.map(_employeeRow),
                        if (_filteredEmployees.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No employees found'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: const Row(
        children: <Widget>[
          Expanded(flex: 2, child: Text('Number')),
          Expanded(flex: 3, child: Text('Name')),
          Expanded(flex: 2, child: Text('Department')),
          Expanded(flex: 3, child: Text('Email')),
        ],
      ),
    );
  }

  Widget _employeeRow(Employee employee) {
    final bool isSelected = _selected == employee;
    return Semantics(
      identifier: employee.rowIdentifier,
      container: true,
      child: InkWell(
        onTap: () => _selectEmployee(employee),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
              left: BorderSide(color: Theme.of(context).dividerColor),
              right: BorderSide(color: Theme.of(context).dividerColor),
            ),
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
          ),
          child: Row(
            children: <Widget>[
              Expanded(flex: 2, child: Text(employee.number)),
              Expanded(flex: 3, child: Text(employee.name)),
              Expanded(flex: 2, child: Text(employee.department)),
              Expanded(flex: 3, child: Text(employee.email)),
            ],
          ),
        ),
      ),
    );
  }
}
