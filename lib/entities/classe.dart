class Classe{
  int nbreEtud;
  String nomClass;
  int? codClass;
  Classe(this.nbreEtud, this.nomClass, [this.codClass]  );
  Map<String, dynamic> toJson() {
    return {
      'codClass': codClass,
      'nomClass': nomClass,
      'nbreEtud': nbreEtud,
    };
  }

  factory Classe.fromJson(Map<String, dynamic> json) {
    return Classe(
      json['nbreEtud'] as int,
      json['nomClass'] as String,
      json['codClass'] as int,
    );
  }
}