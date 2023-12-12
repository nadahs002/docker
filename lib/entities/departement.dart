class Departement {
  int? codDepartement;
  String nomDepartement;

  Departement(this.nomDepartement, [this.codDepartement]);

  Map<String, dynamic> toJson() {
    return {
      'codDepartement': codDepartement,
      'nomDepartement': nomDepartement,
    };
  }

  factory Departement.fromJson(Map<String, dynamic> json) {
    return Departement(
      json['nomDepartement'] as String,
      json['codDepartement'] as int?,
    );
  }
}
