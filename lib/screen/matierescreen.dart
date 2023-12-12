import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../entities/matiere.dart';
import '../service/matiereservice.dart';
import '../template/navbar.dart';
import '../template/dialog/matieredialog.dart';

class MatiereScreen extends StatefulWidget {
  @override
  _MatiereScreenState createState() => _MatiereScreenState();
}

class _MatiereScreenState extends State<MatiereScreen> {
  List<Map<String, dynamic>> classes = [];
  Map<String, dynamic>? selectedClass;
  List<Map<String, dynamic>> matieres = [];

  @override
  void initState() {
    super.initState();
    fetchClassesFromBackend();
  }

  Future<void> fetchClassesFromBackend() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8082/classes'));

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
      // Handle the error more gracefully, e.g., show a user-friendly message
    }
  }

  Future<void> fetchMatieresByClass(int classCode) async {
    final String apiUrl = 'http://10.0.2.2:8082/classes/$classCode/matieres';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('_embedded') &&
            responseData['_embedded'] != null &&
            responseData['_embedded'].containsKey('matieres')) {
          List<dynamic> matieresData = responseData['_embedded']['matieres'];
          List<Map<String, dynamic>> fetchedMatieres =
          List<Map<String, dynamic>>.from(matieresData);
          setState(() {
            matieres = fetchedMatieres;
          });
        } else {
          throw Exception('No matiere found for class with ID: $classCode');
        }
      } else {
        throw Exception('Failed to load matieres for class with ID: $classCode');
      }
    } catch (error) {
      print('Error fetching matieres: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('Matiere'),
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
                await fetchMatieresByClass(classData['codClass']);
              }
            },
          ),
          Expanded(
            child: matieres.isNotEmpty
                ? ListView.builder(
              itemCount: matieres.length,
              itemBuilder: (context, index) {
                var mat = matieres[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(mat['nomMatiere'][0]),
                  ),
                  title: Text("${mat['nomMatiere']}"),
                  subtitle: Text("Duree: , ${mat['dureeH']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _showEditDialog(context, mat),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMatiere(context, mat['id'], index),
                      ),
                    ],
                  ),
                );
              },
            )
                : Center(child: Text('No matiere found')),
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

  void _showEditDialog(BuildContext context, dynamic matiereData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMatiereDialog(
          notifyParent: refresh,
          matiere: Matiere(
            matiereData['dureeH'],
            matiereData['nomMatiere'],
            id: matiereData['id'],
          ),
        );
      },
    );
  }

  void _deleteMatiere(BuildContext context, int id, int index) async {
    await deleteMatiere(id);
    setState(() {
      matieres.removeAt(index);
    });
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMatiereDialog(notifyParent: refresh);
      },
    );
  }

  refresh() {
    setState(() {});
  }
}
