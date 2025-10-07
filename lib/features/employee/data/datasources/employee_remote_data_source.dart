import 'package:dio/dio.dart';
import 'package:qtasnim_frontend_test/core/error/failure.dart';
import 'package:qtasnim_frontend_test/core/utils/api_constants.dart';
import '../models/employee_model.dart';

abstract class EmployeeRemoteDataSource {
  Future<List<EmployeeModel>> getEmployees();
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final Dio dio;

  EmployeeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    try {
      final response = await dio.get(ApiConstants.getEmployees);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EmployeeModel.fromJson(json)).toList();
      } else {
        throw ServerFailure('Failed to fetch employees');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkFailure('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkFailure('No internet connection');
      } else {
        throw ServerFailure('Server error: ${e.message}');
      }
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
  }
}
