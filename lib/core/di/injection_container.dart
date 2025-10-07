import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../utils/api_constants.dart';

final sl = GetIt.instance;

Future<void> init() async {
  
}

Dio _createDio() {
  final dio = Dio();

  dio.options = BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(milliseconds: ApiConstants.connectionTimeout),
    receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
    headers: ApiConstants.headers,
  );
  
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ),
  );

  return dio;
}
