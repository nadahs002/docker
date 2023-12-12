import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tp7_version2/entities/matiere.dart';
import '../entities/student.dart';

Future getAllMatiere() async {
  Response response =
  await http.get(Uri.parse("http://10.0.2.2:8082/matiere/all"));
  return jsonDecode(response.body);
}

Future deleteMatiere(int id) {
  return http
      .delete(Uri.parse("http://10.0.2.2:8082/matiere/delete?id=${id}"));
}

Future addMatiere(Matiere matiere) async {
  print(matiere.dureeH);
  Response response =
  await http.post(Uri.parse("http://10.0.2.2:8082/matiere/add"),
      headers: {"Content-type": "Application/json"},
      body: jsonEncode(<String, dynamic>{
        "nomMatiere": matiere.nomMatiere,
        "dureeH": matiere.dureeH,
        "classe": matiere.classe!.toJson()
      }));
  return response.body;
}

Future updateMatiere(Matiere matiere) async {
  Response response = await http.put(
    Uri.parse("http://10.0.2.2:8082/matiere/update"),
    headers: {"Content-type": "application/json"},
    body: jsonEncode(<String, dynamic>{
      "id": matiere.id,
      "nomMatiere": matiere.nomMatiere,
      "dureeH": matiere.dureeH,
      "classe": matiere.classe!.toJson()
    }),
  );
  return response.body;
}

