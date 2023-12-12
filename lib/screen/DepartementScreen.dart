import 'package:flutter/material.dart';
import '../entities/departement.dart';
import '../service/departementservice.dart';
import '../template/dialog/departementdialog.dart';

class DepartementScreen extends StatefulWidget {
  @override
  _DepartementScreenState createState() => _DepartementScreenState();
}

class _DepartementScreenState extends State<DepartementScreen> {
  final DepartementService _departementService = DepartementService();

  void _openAddEditDepartmentDialog({Departement? departement}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return DepartementDialog(
          departement: departement,
          onSave: (Departement savedDepartement) async {
            if (departement == null) {
              await _departementService.addDepartement(savedDepartement);
            } else {
              await _departementService.updateDepartement(savedDepartement);
            }
            setState(() {}); // Refresh the list
          },
        );
      },
    );
    setState(() {}); // Refresh the list after dialog is closed

  }

  void _deleteDepartment(int? codDepartement) async {
    await _departementService.deleteDepartement(codDepartement);
    setState(() {}); // Refresh the list
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Departments'),
      ),
      body: FutureBuilder(
        future: _departementService.getAllDepartements(),
        builder: (context, AsyncSnapshot<List<Departement>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                var departement = snapshot.data![index];
                return ListTile(
                  title: Text(departement.nomDepartement),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _openAddEditDepartmentDialog(departement: departement),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteDepartment(departement.codDepartement),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () => _openAddEditDepartmentDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
