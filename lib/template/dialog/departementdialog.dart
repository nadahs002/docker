import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../entities/departement.dart';

class DepartementDialog extends StatefulWidget {
  final Departement? departement; // Existing department if editing
  final Function(Departement) onSave;

  DepartementDialog({this.departement, required this.onSave});

  @override
  State<DepartementDialog> createState() => _DepartementDialogState();
}

class _DepartementDialogState extends State<DepartementDialog> {
  late TextEditingController _nomDepartementController;

  @override
  void initState() {
    super.initState();
    _nomDepartementController = TextEditingController(text: widget.departement?.nomDepartement);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.departement == null ? 'Add Department' : 'Edit Department'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: _nomDepartementController,
              decoration: InputDecoration(
                hintText: "Enter Department Name",
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            final departement = Departement(
              _nomDepartementController.text,
              widget.departement?.codDepartement,
            );
            widget.onSave(departement);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nomDepartementController.dispose();
    super.dispose();
  }
}
