import 'package:dartz/dartz.dart';
import 'package:qtasnim_frontend_test/core/error/failure.dart';
import '../entities/employee.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<Employee>>> getEmployees();
  Future<Either<Failure, Employee>> getEmployeeDetail(int id);
  Future<Either<Failure, Employee>> addEmployee(Employee employee);
  Future<Either<Failure, Employee>> updateEmployee(Employee employee);
  Future<Either<Failure, void>> deleteEmployee(int id);
  Future<Either<Failure, List<Employee>>> syncFromApi();
}
