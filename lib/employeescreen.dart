import 'package:appwrite_employee/appwritescervices.dart';
import 'package:appwrite_employee/employee.dart';
import 'package:flutter/material.dart';

class Employeescreen extends StatefulWidget {
  @override
  State<Employeescreen> createState() => _EmployeescreenState();
}

class _EmployeescreenState extends State<Employeescreen> {
  late AppwriteService _appwriteservice;
  late List<Employee> _employees;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final locationController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _appwriteservice = AppwriteService();
    _employees = [];
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    try {
      final tasks = await _appwriteservice.getEmployee();
      setState(() {
        _employees = tasks.map((e) => Employee.fromDocument(e)).toList();
      });
    } catch (e) {
      print('Error loading tasks:$e');
    }
  }

  Future<void> _addEmployee() async {
    final name = nameController.text;
    final age = ageController.text;
    final location = locationController.text;

    if (name.isNotEmpty && age.isNotEmpty && location.isNotEmpty) {
      try {
        await _appwriteservice.addEmployee(name, age, location);
        nameController.clear();
        ageController.clear();
        locationController.clear();

        _loadEmployees();
      } catch (e) {
        print('Error adding task:$e');
      }
    }
  }

  Future<void> _deleteEmployee(String taskId) async {
    try {
      await _appwriteservice.deleteEmployee(taskId);
      _loadEmployees();
    } catch (e) {
      print('Error deleting task:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee screen"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'name'),
              ),
            ),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'age'),
              ),
            ),
            SizedBox(
              height: 40,
              width: 250,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'location'),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
                onPressed: _addEmployee, child: Text('Add employee')),
            SizedBox(height: 30),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(25),
              child: ListView.builder(
                  itemCount: _employees.length,
                  itemBuilder: (context, index) {
                    final employees = _employees[index];
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 233, 142, 172)),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(employees.name),
                              Text(employees.age),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(employees.location),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () => _deleteEmployee(employees.id),
                                    child: Icon(Icons.delete),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ))
          ],
        ),
      ),
    );
  }
}
