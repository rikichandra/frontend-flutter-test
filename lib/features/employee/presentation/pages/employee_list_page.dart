import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qtasnim_frontend_test/core/widgets/loading_indicator.dart';
import 'package:qtasnim_frontend_test/core/di/injection_container.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_empty_state.dart';
import 'add_edit_employee_page.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final TextEditingController _searchController = TextEditingController();
  late EmployeeBloc _employeeBloc;

  @override
  void initState() {
    super.initState();
    _employeeBloc = sl<EmployeeBloc>();
    _employeeBloc.add(GetEmployeesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Management'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sync from Server',
            onPressed: () {
              _showSyncConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _employeeBloc,
        child: BlocConsumer<EmployeeBloc, EmployeeState>(
          listener: (context, state) {
            if (state is EmployeeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is EmployeeOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Refresh the list after operations
              _employeeBloc.add(GetEmployeesEvent());
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search employees...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _employeeBloc.add(const SearchEmployeesEvent(''));
                              },
                            )
                          : null,
                    ),
                    onChanged: (query) {
                      _employeeBloc.add(SearchEmployeesEvent(query));
                    },
                  ),
                ),
                // Content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _employeeBloc.add(GetEmployeesEvent());
                    },
                    child: _buildContent(context, state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEmployee(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSyncConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync from Server'),
        content: const Text(
          'This will refresh data from the server. Your local changes will be preserved. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _employeeBloc.add(SyncEmployeesFromApiEvent());
            },
            child: const Text('Sync'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, EmployeeState state) {
    if (state is EmployeeLoading) {
      return const LoadingIndicator(message: 'Loading employees...');
    } else if (state is EmployeeLoaded) {
      if (state.filteredEmployees.isEmpty) {
        return EmployeeEmptyState(
          message: _searchController.text.isNotEmpty
              ? 'No employees found for "${_searchController.text}"'
              : 'No employees found',
          onRetry: () => _employeeBloc.add(GetEmployeesEvent()),
        );
      }
      return ListView.builder(
        itemCount: state.filteredEmployees.length,
        itemBuilder: (context, index) {
          final employee = state.filteredEmployees[index];
          return EmployeeCard(
            employee: employee,
            onEdit: () => _navigateToEditEmployee(context, employee),
            onDelete: () => _showDeleteDialog(context, employee),
          );
        },
      );
    } else if (state is EmployeeError) {
      return EmployeeEmptyState(
        message: 'Failed to load employees',
        onRetry: () => _employeeBloc.add(GetEmployeesEvent()),
      );
    }
    return const EmployeeEmptyState();
  }

  void _navigateToAddEmployee(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _employeeBloc,
          child: const AddEditEmployeePage(),
        ),
      ),
    );
  }

  void _navigateToEditEmployee(BuildContext context, employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _employeeBloc,
          child: AddEditEmployeePage(employee: employee),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: Text('Are you sure you want to delete ${employee.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _employeeBloc.add(DeleteEmployeeEvent(employee.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
