import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../entities/student.dart';
import '../../service/studentservice.dart';
import 'package:http/http.dart' as http;
import '../../entities/classe.dart';

class AddStudentDialog extends StatefulWidget {
  final Function()? notifyParent;
  Student? student;

  AddStudentDialog({super.key, @required this.notifyParent, this.student});
  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  TextEditingController nomCtrl = TextEditingController();
  TextEditingController prenomCtrl = TextEditingController();
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController dateNaisCtrl = TextEditingController();
  Classe? selectedClass;
  List<Classe> classes = [];

  DateTime selectedDate = DateTime.now();
  String title = "Ajouter Etudiant";
  bool modif = false;
  late int idStudent;
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        dateCtrl.text =
            DateFormat("yyyy-MM-dd").format(DateTime.parse(picked.toString()));
        selectedDate = picked;
      });
    }
  }

  Future<void> fetchClassesFromBackend() async {
    try {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:8082/classes'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('_embedded') && data['_embedded'] != null) {
          List<dynamic> classesData = data['_embedded']['classes'];
          setState(() {
            classes = classesData.map((classData) => Classe.fromJson(classData)).toList();
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
  @override
  void initState() {
    super.initState();
    fetchClassesFromBackend();
    if (widget.student != null) {
      modif = true;
      title = "Modifier Etudiant";
      nomCtrl.text = widget.student!.nom;
      prenomCtrl.text = widget.student!.prenom;
      dateCtrl.text = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(widget.student!.dateNais.toString()));
      idStudent = widget.student!.id!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(title),
            TextFormField(
              controller: nomCtrl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "nom"),
            ),
            TextFormField(
              controller: prenomCtrl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "Prénom"),
            ),
            TextFormField(
              controller: dateCtrl,
              readOnly: true,
              decoration: const InputDecoration(labelText: "Date de naissance"),
              onTap: () {
                _selectDate(context);
              },
            ),
            DropdownButton<Classe>(
              value: selectedClass,
              onChanged: (Classe? newValue) {
                setState(() {
                  selectedClass = newValue;
                });
              },
              items: classes.map<DropdownMenuItem<Classe>>((Classe classe) {
                return DropdownMenuItem<Classe>(
                  value: classe,
                  child: Text(classe.nomClass),
                );
              }).toList(),
            ),

            ElevatedButton(
                onPressed: () async {
                  if (modif == false) {
                    await addStudent(Student(
                      selectedDate.toString(),
                      nomCtrl.text,
                      prenomCtrl.text,
                      classe: selectedClass, // include the selected class when creating a Student
                    ));
                    widget.notifyParent!();
                  } else {
                    await updateStudent(Student(
                      selectedDate.toString(),
                      nomCtrl.text,
                      prenomCtrl.text,
                      id: idStudent,
                      classe: selectedClass, // include the selected class when updating a Student
                    ));
                    widget.notifyParent!();
                  }
                },
                child: const Text("Ajouter")
            )
          ],
        ),
      ),
    );
  }
}
