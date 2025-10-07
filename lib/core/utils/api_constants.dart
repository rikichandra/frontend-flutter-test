class ApiConstants {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String employeesEndpoint = '/users';

  // API Endpoints
  static const String getEmployees = '$baseUrl$employeesEndpoint';
  static String getEmployeeDetail(int id) => '$baseUrl$employeesEndpoint/$id';
  static const String addEmployee = '$baseUrl$employeesEndpoint';
  static String updateEmployee(int id) => '$baseUrl$employeesEndpoint/$id';
  static String deleteEmployee(int id) => '$baseUrl$employeesEndpoint/$id';

  // Timeouts
  static const int connectionTimeout = 5000;
  static const int receiveTimeout = 3000;

  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

