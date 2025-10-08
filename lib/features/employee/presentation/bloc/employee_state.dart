import 'package:equatable/equatable.dart';
import '../../domain/entities/employee.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  final List<Employee> filteredEmployees;

  const EmployeeLoaded({
    required this.employees,
    required this.filteredEmployees,
  });

  @override
  List<Object> get props => [employees, filteredEmployees];

  EmployeeLoaded copyWith({
    List<Employee>? employees,
    List<Employee>? filteredEmployees,
  }) {
    return EmployeeLoaded(
      employees: employees ?? this.employees,
      filteredEmployees: filteredEmployees ?? this.filteredEmployees,
    );
  }
}

class EmployeeDetailLoaded extends EmployeeState {
  final Employee employee;

  const EmployeeDetailLoaded(this.employee);

  @override
  List<Object> get props => [employee];
}

class EmployeeOperationSuccess extends EmployeeState {
  final String message;
  final List<Employee> employees;

  const EmployeeOperationSuccess({
    required this.message,
    required this.employees,
  });

  @override
  List<Object> get props => [message, employees];
}

class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError(this.message);

  @override
  List<Object> get props => [message];
}
