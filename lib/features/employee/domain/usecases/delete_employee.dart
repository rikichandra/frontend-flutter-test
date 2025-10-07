import 'package:dartz/dartz.dart';
import 'package:qtasnim_frontend_test/core/error/failure.dart';
import '../repositories/employee_repository.dart';

class DeleteEmployee {
  final EmployeeRepository repository;

  DeleteEmployee(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteEmployee(id);
  }
}
