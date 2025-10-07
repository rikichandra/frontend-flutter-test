import 'package:dartz/dartz.dart';
import 'package:qtasnim_frontend_test/core/error/failure.dart';
import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class GetEmployeeDetail {
  final EmployeeRepository repository;

  GetEmployeeDetail(this.repository);

  Future<Either<Failure, Employee>> call(int id) async {
    return await repository.getEmployeeDetail(id);
  }
}
