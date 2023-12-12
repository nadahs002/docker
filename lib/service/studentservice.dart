import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../entities/student.dart';

Future getAllStudent() async {
  Response response =
  await http.get(Uri.parse("http://10.0.2.2:8082/etudiant/all"));
  return jsonDecode(response.body);
}

Future deleteStudent(int id) {
  return http
      .delete(Uri.parse("http://10.0.2.2:8082/etudiant/delete?id=${id}"));
}

Future addStudent(Student student) async {
  print(student.dateNais);
  Response response =
  await http.post(Uri.parse("http://10.0.2.2:8082/etudiant/add"),
      headers: {"Content-type": "Application/json"},
      body: jsonEncode(<String, dynamic>{
        "nom": student.nom,
        "prenom": student.prenom,
        "dateNais": DateFormat("yyyy-MM-dd").format(DateTime.parse(student.dateNais)),
        "classe": student.classe!.toJson()
      }));
  return response.body;
}

Future updateStudent(Student student) async {
  Response response =
  await http.put(Uri.parse("http://10.0.2.2:8082/etudiant/update"),
      headers: {"Content-type": "Application/json"},
      body: jsonEncode(<String, dynamic>{
        "id": student.id,
        "nom": student.nom,
        "prenom": student.prenom,
        "dateNais": DateFormat("yyyy-MM-dd").format(DateTime.parse(student.dateNais)),
        "classe": student.classe!.toJson()
      }));
  return response.body;
}
