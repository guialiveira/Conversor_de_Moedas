import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=b2116ce3";

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          )),
    ),
  );
}

Future<Map> getData() async {
  http.Response response =
      await http.get(request); //await faz ficar esperando a resposta
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll(){ //apaga campos
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);//Mostra 2 digitos
    euroController.text = (real/euro).toStringAsFixed(2);//Mostra 2 digitos
  }

  void _dolarChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);////this.dolar pega a varial dolar que já existe fora da função
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);//Convertendo para real para depois converter para euro
  }

  void _euroChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);//Mostra 2 digitos
    dolarController.text = (euro * this.euro/ dolar).toStringAsFixed(2);//Mostra 2 digitos
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        //Map pq o sjon vai retornar um map
        future: getData(), //pedindo dados para o futuro
        builder: (context, snapshot) {
          //builder expecificar oque vai ser mostrado na tela em cada um dos casos
          switch (snapshot.connectionState) {
            case ConnectionState.none: // se não tiver conectado
            case ConnectionState.waiting: //ou esperando uma conecção
              return Center(
                  child: Text(
                "Carregando Dados...",
                style: TextStyle(color: Colors.amber, fontSize: 25.0),
                textAlign: TextAlign.center,
              ));
            default: // Default vai ser caso os dados tenham sido obitidos
              if (snapshot.hasError) {
                // caso tenha retornado um erro
                return Center(
                    child: Text(
                  "Erro ao Carregar Dados :(",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              } else {
                //caso tenha dado certo
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  //Tela que rola
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 150.0, color: Colors.amber),
                      buildTexatFild("Reais", "R\$", realController, _realChanged),
                      Divider(),
                      buildTexatFild("Dólares", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTexatFild("Euros", "€", euroController, _euroChanged)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTexatFild(String label, String prefix, TextEditingController c, Function f) {//Cria textFilds
  return TextField(
      controller: c,
      onChanged: f,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.amber, fontSize: 25.0));
}
