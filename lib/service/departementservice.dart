import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/departement.dart';

class DepartementService {
  final String apiUrl = "http://10.0.2.2:8082/departement";

  Future<List<Departement>> getAllDepartements() async {
    var response = await http.get(Uri.parse(apiUrl + "/all"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data.map((departement) => Departement.fromJson(departement)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<Departement> addDepartement(Departement departement) async {
    var response = await http.post(
      Uri.parse(apiUrl + "/add"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(departement.toJson()),
    );
    if (response.statusCode == 201) {
      return Departement.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add department');
    }
  }
  Future<Departement> updateDepartement(Departement departement) async {
    var response = await http.put(
      Uri.parse(apiUrl + "/update"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(departement.toJson()),
    );
    if (response.statusCode == 200) {
      return Departement.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update department');
    }
  }

  Future<void> deleteDepartement(int? codDepartement) async {
    var response = await http.delete(Uri.parse(apiUrl + "/delete?id=$codDepartement"));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete department');
    }
  }

// Implement similar methods for update and delete
}
