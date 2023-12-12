import 'dart:convert';

import '../entities/abscence.dart';
import 'package:http/http.dart' as http;

class AbsenceService {
  final String apiUrl = "http://10.0.2.2:8082/absence";



  Future<List<Absence>> getAllAbsences() async {
    try {
      var response = await http.get(Uri.parse("http://10.0.2.2:8082/absences/all"));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        return data.map((absence) => Absence.fromJson(absence)).toList();
      } else {
        throw Exception('Failed to load absences: ${response.statusCode}');
      }
    } catch (error) {
      print('Network error: $error');
      throw Exception('Failed to load absences');
    }
  }



  Future<Absence> addAbsence(Absence absence) async {
    var response = await http.post(
      Uri.parse("http://10.0.2.2:8082/absences/add"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(absence.toJson()),
    );
    if (response.statusCode == 201) {
      return Absence.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add absence');
    }
  }

  Future<Absence> updateAbsence(Absence absence) async {
    var response = await http.put(
      Uri.parse(apiUrl + "/update"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(absence.toJson()),
    );
    if (response.statusCode == 200) {
      return Absence.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update absence');
    }
  }

  Future<void> deleteAbsence({required int codMat, required int idEtud, required DateTime dateA}) async {
    var response = await http.delete(Uri.parse(apiUrl + "/delete?codMat=$codMat&idEtud=$idEtud&dateA=${dateA.toIso8601String()}"));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete absence');
    }
  }
}