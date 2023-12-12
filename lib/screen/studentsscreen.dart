import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../entities/student.dart';
import '../service/studentservice.dart';
import '../template/navbar.dart';
import '../template/dialog/studentdialog.dart';
import 'package:http/http.dart' as http;

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  List<Map<String, dynamic>> classes = [];
  Map<String, dynamic>? selectedClass;
  List<dynamic> students = [];
  @override
  void initState() {
    super.initState();
    fetchClassesFromBackend();
  }
// Method to fetch classes from the backend
  Future<void> fetchClassesFromBackend() async {
    try {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:8082/classes'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('_embedded') && data['_embedded'] != null) {
          List<dynamic> classesData = data['_embedded']['classes'];
          setState(() {
            classes = List<Map<String, dynamic>>.from(classesData);
          });
        } else {
          throw Exception('No classes found');
        }
      } else {
        throw Exception('Failed to load classes');
      }
    } catch (error) {
      print('Error fetching classes: $error');
    }
  }

  Future<void> fetchStudentsByClass(int classCode) async {
    final String apiUrl = 'http://10.0.2.2:8082/classes/$classCode/etudiants';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('_embedded') &&
            responseData['_embedded'] != null &&
            responseData['_embedded'].containsKey('etudiants')) {
          List<dynamic> studentsData = responseData['_embedded']['etudiants'];
          List<Map<String, dynamic>> fetchedStudents =
          List<Map<String, dynamic>>.from(studentsData);
          setState(() {
            students =
                fetchedStudents; // Update the state with fetched students
          });
        } else {
          throw Exception('No students found for class with ID: $classCode');
        }
      } else {
        throw Exception(
            'Failed to load students for class with ID: $classCode');
      }
    } catch (error) {
      throw Exception('Error fetching students: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('Etudiant'),
      body: Column(
        children: [
          DropdownButton<Map<String, dynamic>>(
            value: selectedClass,
            hint: Text('Select a class'),
            items: classes.map<DropdownMenuItem<Map<String, dynamic>>>(
                  (classData) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: classData,
                  child: Text(classData['nomClass'].toString()),
                );
              },
            ).toList(),
            onChanged: (Map<String, dynamic>? classData) async {
              setState(() {
                selectedClass = classData;
              });
              if (classData != null) {
                await fetchStudentsByClass(classData['codClass']);
              }
            },
          ),
          Expanded(
            child: students.isNotEmpty
                ? ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(student['nom'][0]),
                  ),
                  title: Text("${student['nom']} ${student['prenom']}"),
                  subtitle: Text('Date de Naissance: ' +
                      DateFormat("dd-MM-yyyy")
                          .format(DateTime.parse(student['dateNais']))),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () =>
                            _showEditDialog(context, student),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _deleteStudent(context, student['id'], index, students),
                      ),
                    ],
                  ),
                );
              },
            )
                : Center(child: Text('No students found')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showEditDialog(BuildContext context, dynamic studentData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddStudentDialog(
          notifyParent: refresh,
          student:Student(
            studentData['dateNais'],
            studentData['nom'],
            studentData['prenom'],
            id: studentData['id'],
          )
        );
      },
    );
  }

  void _deleteStudent(BuildContext context, int id, int index, dynamic snapshotData) async {
    await deleteStudent(id);
    setState(() {
      snapshotData.removeAt(index);
    });
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddStudentDialog(notifyParent: refresh);
      },
    );
  }

  refresh() {
    setState(() {});
  }
}
