import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/employee.dart';
import '../../domain/usecases/get_employees.dart';
import '../../domain/usecases/get_employee_detail.dart';
import '../../domain/usecases/add_employee.dart';
import '../../domain/usecases/update_employee.dart';
import '../../domain/usecases/delete_employee.dart';
import '../../domain/usecases/sync_employees_from_api.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployees getEmployees;
  final GetEmployeeDetail getEmployeeDetail;
  final AddEmployee addEmployee;
  final UpdateEmployee updateEmployee;
  final DeleteEmployee deleteEmployee;
  final SyncEmployeesFromApi syncEmployeesFromApi;

  List<Employee> _allEmployees = [];

  EmployeeBloc({
    required this.getEmployees,
    required this.getEmployeeDetail,
    required this.addEmployee,
    required this.updateEmployee,
    required this.deleteEmployee,
    required this.syncEmployeesFromApi,
  }) : super(EmployeeInitial()) {
    on<GetEmployeesEvent>(_onGetEmployees);
    on<GetEmployeeDetailEvent>(_onGetEmployeeDetail);
    on<AddEmployeeEvent>(_onAddEmployee);
    on<UpdateEmployeeEvent>(_onUpdateEmployee);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
    on<SyncEmployeesFromApiEvent>(_onSyncEmployeesFromApi);
    on<SearchEmployeesEvent>(_onSearchEmployees);
  }

  Future<void> _onGetEmployees(
    GetEmployeesEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await getEmployees();

    result.fold(
      (failure) => emit(EmployeeError(failure.toString())),
      (employees) {
        _allEmployees = employees;
        emit(EmployeeLoaded(
          employees: employees,
          filteredEmployees: employees,
        ));
      },
    );
  }

  Future<void> _onGetEmployeeDetail(
    GetEmployeeDetailEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await getEmployeeDetail(event.id);

    result.fold(
      (failure) => emit(EmployeeError(failure.toString())),
      (employee) => emit(EmployeeDetailLoaded(employee)),
    );
  }

  Future<void> _onAddEmployee(
    AddEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await addEmployee(event.employee);

    result.fold(
      (failure) => emit(EmployeeError(failure.toString())),
      (employee) {
        _allEmployees.add(employee);
        emit(EmployeeOperationSuccess(
          message: 'Employee added successfully',
          employees: _allEmployees,
        ));
      },
    );
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await updateEmployee(event.employee);

    result.fold(
      (failure) => emit(EmployeeError(failure.toString())),
      (employee) {
        final index = _allEmployees.indexWhere((e) => e.id == employee.id);
        if (index != -1) {
          _allEmployees[index] = employee;
        }
        emit(EmployeeOperationSuccess(
          message: 'Employee updated successfully',
          employees: _allEmployees,
        ));
      },
    );
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await deleteEmployee(event.id);

    result.fold(
      (failure) => emit(EmployeeError(failure.toString())),
      (_) {
        _allEmployees.removeWhere((employee) => employee.id == event.id);
        emit(EmployeeOperationSuccess(
          message: 'Employee deleted successfully',
          employees: _allEmployees,
        ));
      },
    );
  }

  Future<void> _onSyncEmployeesFromApi(
    SyncEmployeesFromApiEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    final result = await syncEmployeesFromApi();

    result.fold(
      (failure) => emit(EmployeeError(failure.toString())),
      (employees) {
        _allEmployees = employees;
        emit(EmployeeOperationSuccess(
          message: 'Data synchronized successfully',
          employees: employees,
        ));
      },
    );
  }

  void _onSearchEmployees(
    SearchEmployeesEvent event,
    Emitter<EmployeeState> emit,
  ) {
    if (state is EmployeeLoaded) {
      final currentState = state as EmployeeLoaded;

      if (event.query.isEmpty) {
        emit(currentState.copyWith(filteredEmployees: _allEmployees));
      } else {
        final filteredEmployees = _allEmployees
            .where((employee) =>
                employee.name.toLowerCase().contains(event.query.toLowerCase()) ||
                employee.position.toLowerCase().contains(event.query.toLowerCase()))
            .toList();

        emit(currentState.copyWith(filteredEmployees: filteredEmployees));
      }
    }
  }
}
