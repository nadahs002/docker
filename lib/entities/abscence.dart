import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Absence {
  int? codMat;
  int? idEtud;
  DateTime? dateA;
  int? nha;

  Absence({this.codMat, this.idEtud, this.dateA, this.nha});

  Map<String, dynamic> toJson() {
    return {
      'codMat': codMat,
      'idEtud': idEtud,
      'dateA': dateA?.toIso8601String(),
      'nha': nha,
    };
  }

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      codMat: json['codMat'] as int?,
      idEtud: json['idEtud'] as int?,
      dateA: DateTime.parse(json['dateA'] as String),
      nha: json['nha'] as int?,
    );
  }
}