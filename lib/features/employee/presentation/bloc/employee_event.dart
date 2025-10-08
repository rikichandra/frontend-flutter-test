import 'package:equatable/equatable.dart';
import '../../domain/entities/employee.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class GetEmployeesEvent extends EmployeeEvent {}

class GetEmployeeDetailEvent extends EmployeeEvent {
  final int id;

  const GetEmployeeDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddEmployeeEvent extends EmployeeEvent {
  final Employee employee;

  const AddEmployeeEvent(this.employee);

  @override
  List<Object> get props => [employee];
}

class UpdateEmployeeEvent extends EmployeeEvent {
  final Employee employee;

  const UpdateEmployeeEvent(this.employee);

  @override
  List<Object> get props => [employee];
}

class DeleteEmployeeEvent extends EmployeeEvent {
  final int id;

  const DeleteEmployeeEvent(this.id);

  @override
  List<Object> get props => [id];
}

class SyncEmployeesFromApiEvent extends EmployeeEvent {}

class SearchEmployeesEvent extends EmployeeEvent {
  final String query;

  const SearchEmployeesEvent(this.query);

  @override
  List<Object> get props => [query];
}
