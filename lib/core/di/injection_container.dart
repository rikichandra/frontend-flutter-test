import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import '../../features/employee/data/models/employee_model.dart';
import '../../features/employee/data/datasources/employee_remote_data_source.dart';
import '../../features/employee/data/datasources/employee_local_data_source.dart';
import '../../features/employee/data/repositories/employee_repository_impl.dart';
import '../../features/employee/domain/repositories/employee_repository.dart';
import '../../features/employee/domain/usecases/get_employees.dart';
import '../../features/employee/domain/usecases/get_employee_detail.dart';
import '../../features/employee/domain/usecases/add_employee.dart';
import '../../features/employee/domain/usecases/update_employee.dart';
import '../../features/employee/domain/usecases/delete_employee.dart';
import '../../features/employee/domain/usecases/sync_employees_from_api.dart';
import '../../features/employee/presentation/bloc/employee_bloc.dart';
import '../utils/api_constants.dart';

final sl = GetIt.instance;

Future<void> init() async {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(EmployeeModelAdapter());
  }

  sl.registerFactory(
    () => EmployeeBloc(
      getEmployees: sl(),
      getEmployeeDetail: sl(),
      addEmployee: sl(),
      updateEmployee: sl(),
      deleteEmployee: sl(),
      syncEmployeesFromApi: sl(),
    ),
  );
  
  sl.registerLazySingleton(() => GetEmployees(sl()));
  sl.registerLazySingleton(() => GetEmployeeDetail(sl()));
  sl.registerLazySingleton(() => AddEmployee(sl()));
  sl.registerLazySingleton(() => UpdateEmployee(sl()));
  sl.registerLazySingleton(() => DeleteEmployee(sl()));
  sl.registerLazySingleton(() => SyncEmployeesFromApi(sl()));
  
  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  
  sl.registerLazySingleton<EmployeeRemoteDataSource>(
    () => EmployeeRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<EmployeeLocalDataSource>(
    () => EmployeeLocalDataSourceImpl(),
  );
  
  sl.registerLazySingleton(() => _createDio());
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
