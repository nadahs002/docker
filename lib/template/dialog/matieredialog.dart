import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp7_version2/entities/matiere.dart';
import 'package:tp7_version2/service/matiereservice.dart';
import '../../entities/student.dart';
import 'package:http/http.dart' as http;
import '../../entities/classe.dart';

class AddMatiereDialog extends StatefulWidget {
  final Function()? notifyParent;
  Matiere? matiere;

  AddMatiereDialog({super.key, @required this.notifyParent, this.matiere});

  @override
  State<AddMatiereDialog> createState() => _AddMatiereDialogState();
}

class _AddMatiereDialogState extends State<AddMatiereDialog> {
  TextEditingController nomMatCtrl = TextEditingController();
  TextEditingController dureeHCtrl = TextEditingController();
  Classe? selectedClass;
  List<Classe> classes = [];


  String title = "Ajouter Matiere";
  bool modif = false;
  late int idMatiere;


  Future<void> fetchClassesFromBackend() async {
    try {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:8082/classes'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('_embedded') && data['_embedded'] != null) {
          List<dynamic> classesData = data['_embedded']['classes'];
          setState(() {
            classes = classesData.map((classData) => Classe.fromJson(classData))
                .toList();
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
    if (widget.matiere != null) {
      modif = true;
      title = "Modifier Matiere";
      nomMatCtrl.text = widget.matiere!.nomMatiere;
      dureeHCtrl.text = widget.matiere!.dureeH;

      idMatiere = widget.matiere!.id!;
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
              controller: nomMatCtrl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "nomMatiere"),
            ),
            TextFormField(
              controller: dureeHCtrl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "dureeH"),
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
                    await addMatiere(Matiere(

                      nomMatCtrl.text,
                      dureeHCtrl.text,
                      classe: selectedClass, // include the selected class when creating a Student
                    ));
                    widget.notifyParent!();
                  } else {
                    await updateMatiere(Matiere(

                      nomMatCtrl.text,
                      dureeHCtrl.text,
                      id: idMatiere,
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

