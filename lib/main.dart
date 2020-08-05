import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

const request = "https://api.hgbrasil.com/finance?format=json&key=b2116ce3";

void main() async{

  http.Response response = await http.get(request); //await faz ficar esperando a resposta
  print(response.body);

  runApp(MaterialApp(
    home: Container()
  ));
}