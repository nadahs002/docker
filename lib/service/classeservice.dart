import 'dart:convert';

import 'package:http/http.dart' as http ;
import 'package:http/http.dart';
import '../entities/classe.dart';

Future getAllClasses() async{

  Response response =await  http.get(Uri.parse("http://10.0.2.2:8082/class/all"));
  return jsonDecode(response.body);

}

Future deleteClass(int id){
  return http.delete(Uri.parse("http://10.0.2.2:8082/class/delete?id=${id}"));
}


Future addClass(Classe classe)async
{

  Response response = await http.post(Uri.parse("http://10.0.2.2:8082/class/add"),
      headers:{
        "Content-type":"Application/json"
      },body:jsonEncode(<String,dynamic>{
        "nomClass":classe.nomClass,
        "nbreEtud":classe.nbreEtud
      }
      ));

  return response.body;
}

Future updateClasse(Classe classe)async
{

  Response response = await http.put(Uri.parse("http://10.0.2.2:8082/class/update"),
      headers:{
        "Content-type":"Application/json"
      },body:jsonEncode(<String,dynamic>{
        "codClass":classe.codClass,
        "nomClass":classe.nomClass,
        "nbreEtud":classe.nbreEtud
      }
      ));

  return response.body;
}
