import 'package:hive/hive.dart';
import 'package:qtasnim_frontend_test/core/error/failure.dart';
import '../models/employee_model.dart';

abstract class EmployeeLocalDataSource {
  Future<List<EmployeeModel>> getEmployees();
  Future<EmployeeModel> getEmployeeDetail(int id);
  Future<EmployeeModel> addEmployee(EmployeeModel employee);
  Future<EmployeeModel> updateEmployee(EmployeeModel employee);
  Future<void> deleteEmployee(int id);
  Future<void> syncWithApiData(List<EmployeeModel> employees);
  Future<bool> hasData();
  Future<bool> isEmpty();
}

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource {
  static const String boxName = 'employees';

  Future<Box<EmployeeModel>> get _box async => await Hive.openBox<EmployeeModel>(boxName);

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    try {
      final box = await _box;
      return box.values.toList();
    } catch (e) {
      throw CacheFailure('Failed to get employees from cache: $e');
    }
  }

  @override
  Future<EmployeeModel> getEmployeeDetail(int id) async {
    try {
      final box = await _box;
      final employee = box.get(id);
      if (employee != null) {
        return employee;
      } else {
        throw CacheFailure('Employee not found in cache');
      }
    } catch (e) {
      throw CacheFailure('Failed to get employee detail from cache: $e');
    }
  }

  @override
  Future<EmployeeModel> addEmployee(EmployeeModel employee) async {
    try {
      final box = await _box;
      await box.put(employee.id, employee);
      return employee;
    } catch (e) {
      throw CacheFailure('Failed to add employee to cache: $e');
    }
  }

  @override
  Future<EmployeeModel> updateEmployee(EmployeeModel employee) async {
    try {
      final box = await _box;
      if (!box.containsKey(employee.id)) {
        throw CacheFailure('Employee not found in cache');
      }
      await box.put(employee.id, employee);
      return employee;
    } catch (e) {
      throw CacheFailure('Failed to update employee in cache: $e');
    }
  }

  @override
  Future<void> deleteEmployee(int id) async {
    try {
      final box = await _box;
      if (!box.containsKey(id)) {
        throw CacheFailure('Employee not found in cache');
      }
      await box.delete(id);
    } catch (e) {
      throw CacheFailure('Failed to delete employee from cache: $e');
    }
  }

  @override
  Future<void> syncWithApiData(List<EmployeeModel> employees) async {
    try {
      final box = await _box;

      final existingEmployees = box.values.where((emp) => emp.isLocal).toList();

      await box.clear();

      for (final employee in employees) {
        await box.put(employee.id, employee);
      }
      
      for (final localEmployee in existingEmployees) {
        await box.put(localEmployee.id, localEmployee);
      }
    } catch (e) {
      throw CacheFailure('Failed to sync with API data: $e');
    }
  }

  @override
  Future<bool> hasData() async {
    try {
      final box = await _box;
      return box.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isEmpty() async {
    try {
      final box = await _box;
      return box.isEmpty;
    } catch (e) {
      return true;
    }
  }
}
