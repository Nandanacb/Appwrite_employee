import 'package:appwrite/models.dart';

class Employee {
  final String id;
  final String name;
  final String age;
  final String location;

  Employee({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
  });

  factory Employee.fromDocument(Document doc) {
    return Employee(
      id: doc.$id,
      name: doc.data['name'],
      age: doc.data['age'],
      location: doc.data['location'],
    );
  }
}
