import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qtasnim_frontend_test/core/utils/helpers.dart';
import 'package:qtasnim_frontend_test/core/widgets/input_field.dart';
import 'package:qtasnim_frontend_test/core/widgets/loading_indicator.dart';
import 'package:qtasnim_frontend_test/core/widgets/primary_button.dart';
import 'package:qtasnim_frontend_test/core/widgets/salary_input_formatter.dart';
import '../../domain/entities/employee.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';

class AddEditEmployeePage extends StatefulWidget {
  final Employee? employee;

  const AddEditEmployeePage({super.key, this.employee});

  @override
  State<AddEditEmployeePage> createState() => _AddEditEmployeePageState();
}

class _AddEditEmployeePageState extends State<AddEditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  bool get _isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _populateFields();
    }
  }

  void _populateFields() {
    final employee = widget.employee!;
    _nameController.text = employee.name;
    _positionController.text = employee.position;
    _salaryController.text = Helpers.formatNumberWithSeparator(employee.salary.toInt().toString());
    _addressController.text = employee.address;
    _phoneController.text = employee.phoneNumber;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _salaryController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Employee' : 'Add Employee'),
      ),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeOperationSuccess) {
            Navigator.pop(context);
          } else if (state is EmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const LoadingIndicator(message: 'Saving employee...');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    label: 'Name',
                    hint: 'Enter employee name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    label: 'Position',
                    hint: 'Enter position/job title',
                    controller: _positionController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Position is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    label: 'Salary',
                    hint: 'Enter salary amount',
                    controller: _salaryController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [SalaryInputFormatter()],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Salary is required';
                      }
                      if (!Helpers.isValidSalaryString(value)) {
                        return 'Please enter a valid salary amount (min Rp 1.000.000)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    label: 'Address',
                    hint: 'Enter address',
                    controller: _addressController,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Address is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    label: 'Phone Number',
                    hint: 'Enter phone number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!Helpers.isValidPhoneNumber(value)) {
                        return 'Please enter a valid phone number (min 10 digits)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: _isEditing ? 'Update Employee' : 'Save Employee',
                    onPressed: _saveEmployee,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        id: _isEditing ? widget.employee!.id : 0, // Let repository generate the ID
        name: Helpers.capitalizeWords(_nameController.text.trim()),
        position: Helpers.capitalizeWords(_positionController.text.trim()),
        salary: Helpers.parseSalary(_salaryController.text.trim()),
        address: _addressController.text.trim(),
        phoneNumber: Helpers.formatPhoneNumber(_phoneController.text.trim()),
      );

      if (_isEditing) {
        context.read<EmployeeBloc>().add(UpdateEmployeeEvent(employee));
      } else {
        context.read<EmployeeBloc>().add(AddEmployeeEvent(employee));
      }
    }
  }
}
