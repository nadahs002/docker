import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../entities/abscence.dart';
import '../service/abscenceservice.dart';
import '../template/dialog/abscencedialog.dart';

class AbsenceScreen extends StatefulWidget {
  @override
  _AbsenceScreenState createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  final AbsenceService _absenceService = AbsenceService();

  void _openAddEditAbsenceDialog({Absence? absence}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AbsenceDialog(
          absence: absence,
          onSave: (Absence savedAbsence) async {
            if (absence == null) {
              await _absenceService.addAbsence(savedAbsence);
            } else {
              await _absenceService.updateAbsence(savedAbsence);
            }
            setState(() {}); // Refresh the list
          },
        );
      },
    );
    setState(() {}); // Refresh the list after dialog is closed
  }

  void _deleteAbsence({required int codMat, required int idEtud, required DateTime dateA}) async {
    await _absenceService.deleteAbsence(codMat: codMat, idEtud: idEtud, dateA: dateA);
    setState(() {}); // Refresh the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absences'),
      ),
      body: FutureBuilder(
        future: _absenceService.getAllAbsences(),
        builder: (context, AsyncSnapshot<List<Absence>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                var absence = snapshot.data![index];
                return ListTile(
                  title: Text('Absence ${index + 1}'),
                  subtitle: Text('Date: ${absence.dateA?.toLocal().toString()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _openAddEditAbsenceDialog(absence: absence),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteAbsence(
                          codMat: absence.codMat!,
                          idEtud: absence.idEtud!,
                          dateA: absence.dateA!,
                        ),
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
        onPressed: () => _openAddEditAbsenceDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}