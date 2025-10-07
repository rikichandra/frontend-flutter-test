import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/employee.dart';

part 'employee_model.g.dart';

@HiveType(typeId: 0)
class EmployeeModel extends Equatable {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String position;

  @HiveField(3)
  final double salary;

  @HiveField(4)
  final String address;

  @HiveField(5)
  final String phoneNumber;

  @HiveField(6)
  final bool isLocal; // Flag to identify local vs API data

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.position,
    required this.salary,
    required this.address,
    required this.phoneNumber,
    this.isLocal = false,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      position: json['company']?['name'] ?? 'Unknown Position',
      salary: 50000.0, // Default salary since API doesn't provide this
      address: _buildAddress(json['address']),
      phoneNumber: json['phone'] ?? '',
      isLocal: false, // Data from API
    );
  }

  static String _buildAddress(Map<String, dynamic>? address) {
    if (address == null) return '';
    final street = address['street'] ?? '';
    final suite = address['suite'] ?? '';
    final city = address['city'] ?? '';
    final zipcode = address['zipcode'] ?? '';

    return [street, suite, city, zipcode]
        .where((part) => part.isNotEmpty)
        .join(', ');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': {'name': position},
      'salary': salary,
      'address': {'street': address},
      'phone': phoneNumber,
      'isLocal': isLocal,
    };
  }

  Employee toEntity() {
    return Employee(
      id: id,
      name: name,
      position: position,
      salary: salary,
      address: address,
      phoneNumber: phoneNumber,
    );
  }

  factory EmployeeModel.fromEntity(Employee employee) {
    return EmployeeModel(
      id: employee.id,
      name: employee.name,
      position: employee.position,
      salary: employee.salary,
      address: employee.address,
      phoneNumber: employee.phoneNumber,
      isLocal: true, // Data from local operations
    );
  }

  EmployeeModel copyWith({
    int? id,
    String? name,
    String? position,
    double? salary,
    String? address,
    String? phoneNumber,
    bool? isLocal,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      salary: salary ?? this.salary,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isLocal: isLocal ?? this.isLocal,
    );
  }

  @override
  List<Object> get props => [id, name, position, salary, address, phoneNumber, isLocal];
}
