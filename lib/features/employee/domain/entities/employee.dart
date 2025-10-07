import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final int id;
  final String name;
  final String position;
  final double salary;
  final String address;
  final String phoneNumber;

  const Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.salary,
    required this.address,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [
        id,
        name,
        position,
        salary,
        address,
        phoneNumber,
      ];

  Employee copyWith({
    int? id,
    String? name,
    String? position,
    double? salary,
    String? address,
    String? phoneNumber,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      salary: salary ?? this.salary,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
