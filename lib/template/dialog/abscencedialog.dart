import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../entities/abscence.dart';



class AbsenceDialog extends StatefulWidget {
  final Absence? absence; // Existing absence if editing
  final Function(Absence) onSave;

  AbsenceDialog({this.absence, required this.onSave});

  @override
  State<AbsenceDialog> createState() => _AbsenceDialogState();
}

class _AbsenceDialogState extends State<AbsenceDialog> {
  late TextEditingController _codMatController;
  late TextEditingController _idEtudController;
  late TextEditingController _dateAController;
  late TextEditingController _nhaController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _codMatController = TextEditingController(text: widget.absence?.codMat?.toString());
    _idEtudController = TextEditingController(text: widget.absence?.idEtud?.toString());
    _dateAController = TextEditingController(
      text: widget.absence?.dateA != null
          ? DateFormat('yyyy-MM-dd').format(widget.absence!.dateA!)
          : '',
    );
    _nhaController = TextEditingController(text: widget.absence?.nha?.toString());
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.absence?.dateA ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateAController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.absence == null ? 'Add Absence' : 'Edit Absence'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _codMatController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'CodMat',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CodMat';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idEtudController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'IdEtud',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter IdEtud';
                  }
                  return null;
                },
              ),
              // Your other form fields go here

              TextFormField(
                controller: _dateAController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nhaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'NHA',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter NHA';
                  }
                  return null;
                },
              ),
            ],
          ),
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
            if (_formKey.currentState!.validate()) {
              final absence = Absence(
                codMat: int.parse(_codMatController.text),
                idEtud: int.parse(_idEtudController.text),
                dateA: DateFormat('yyyy-MM-dd').parse(_dateAController.text),
                nha: int.parse(_nhaController.text),
                // Add other fields as needed
              );
              widget.onSave(absence);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _codMatController.dispose();
    _idEtudController.dispose();
    _dateAController.dispose();
    _nhaController.dispose();
    super.dispose();
  }
}
