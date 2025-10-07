import 'package:dartz/dartz.dart';
import 'package:qtasnim_frontend_test/core/error/failure.dart';
import 'package:qtasnim_frontend_test/core/utils/helpers.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_local_data_source.dart';
import '../datasources/employee_remote_data_source.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;
  final EmployeeLocalDataSource localDataSource;

  EmployeeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Employee>>> getEmployees() async {
    try {
      // Check if local storage is empty - if so, sync from API first
      final isEmpty = await localDataSource.isEmpty();
      if (isEmpty) {
        await _syncFromApiInternal();
      }

      // Always return data from local storage
      final localEmployees = await localDataSource.getEmployees();
      final employees = localEmployees.map((model) => model.toEntity()).toList();
      return Right(employees);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(CacheFailure('Failed to get employees: $e'));
    }
  }

  @override
  Future<Either<Failure, Employee>> getEmployeeDetail(int id) async {
    try {
      final localEmployee = await localDataSource.getEmployeeDetail(id);
      return Right(localEmployee.toEntity());
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(CacheFailure('Failed to get employee detail: $e'));
    }
  }

  @override
  Future<Either<Failure, Employee>> addEmployee(Employee employee) async {
    try {
      // Generate local ID for new employee
      final employeeWithLocalId = employee.copyWith(
        id: Helpers.generateLocalId(),
      );

      final employeeModel = EmployeeModel.fromEntity(employeeWithLocalId);
      final result = await localDataSource.addEmployee(employeeModel);

      return Right(result.toEntity());
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(CacheFailure('Failed to add employee: $e'));
    }
  }

  @override
  Future<Either<Failure, Employee>> updateEmployee(Employee employee) async {
    try {
      final employeeModel = EmployeeModel.fromEntity(employee).copyWith(isLocal: true);
      final result = await localDataSource.updateEmployee(employeeModel);

      return Right(result.toEntity());
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(CacheFailure('Failed to update employee: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployee(int id) async {
    try {
      await localDataSource.deleteEmployee(id);
      return const Right(null);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(CacheFailure('Failed to delete employee: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Employee>>> syncFromApi() async {
    try {
      await _syncFromApiInternal();
      final localEmployees = await localDataSource.getEmployees();
      final employees = localEmployees.map((model) => model.toEntity()).toList();
      return Right(employees);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure('Failed to sync from API: $e'));
    }
  }

  Future<void> _syncFromApiInternal() async {
    final remoteEmployees = await remoteDataSource.getEmployees();
    await localDataSource.syncWithApiData(remoteEmployees);
  }
}
