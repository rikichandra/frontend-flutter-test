import 'package:dartz/dartz.dart';
import 'package:qtasnim_frontend_test/core/error/failure.dart';
import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class AddEmployee {
  final EmployeeRepository repository;

  AddEmployee(this.repository);

  Future<Either<Failure, Employee>> call(Employee employee) async {
    return await repository.addEmployee(employee);
  }
}
