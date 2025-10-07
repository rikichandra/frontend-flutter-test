import 'package:dartz/dartz.dart';
import 'package:qtasnim_frontend_test/core/error/failure.dart';
import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class SyncEmployeesFromApi {
  final EmployeeRepository repository;

  SyncEmployeesFromApi(this.repository);

  Future<Either<Failure, List<Employee>>> call() async {
    return await repository.syncFromApi();
  }
}
