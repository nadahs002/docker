import 'classe.dart';

class Student{
  String dateNais , nom , prenom ;
  int? id;
  Classe? classe;
  Student(this.dateNais, this.nom , this.prenom , {this.classe, this.id});}