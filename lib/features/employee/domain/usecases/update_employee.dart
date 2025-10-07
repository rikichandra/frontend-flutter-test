import 'package:dartz/dartz.dart';
import 'package:qtasnim_frontend_test/core/error/failure.dart';
import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class UpdateEmployee {
  final EmployeeRepository repository;

  UpdateEmployee(this.repository);

  Future<Either<Failure, Employee>> call(Employee employee) async {
    return await repository.updateEmployee(employee);
  }
}
