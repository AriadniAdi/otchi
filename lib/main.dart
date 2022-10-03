import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:ot/post_detail.dart';
// import 'package:ot/post_model.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OT - Organizador de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'OT - Organizador de Tarefas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('OT - Organizador de Tarefas'),
        ),
        body: Column(children: [
          Center(
              heightFactor: 2,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastrarTarefa()),
                  );
                },
                child: const Text('Nova Tarefa',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                    )),
              )),
          const Text('Tarefa 1',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 32,
                color: Colors.black,
              ))
        ]));
  }
}

class CadastrarTarefa extends StatefulWidget {
  @override
  State<CadastrarTarefa> createState() => _CadastrarTarefaState();
}

class _CadastrarTarefaState extends State<CadastrarTarefa> {
  final List<String> _locations = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];
  String? _selectedLocation;
  final TimeOfDay _time = TimeOfDay.now();
  late TimeOfDay picked;
  bool? diassem = true;
  bool? sabados = false;
  bool? domingos = false;
  String nome = "";
  String prioridade = "";
  String horario = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar a tarefa",
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
            )),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o nome da tarefa';
                }
                return value;
              },
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Informe o nome da tarefa',
              ),
              onChanged: (newValue) {
                nome = newValue;
              },
            ),
            DropdownButton(
              hint: const Text('Escolha a prioridade'),
              value: _selectedLocation,
              onChanged: (newValue) {
                prioridade = newValue.toString();
              },
              items: _locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                selectTime(context);
              },
              child: const Text('Definir Horário Limite',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                  )),
            ),
            CheckboxListTile(
              title: const Text('Dias de semana'),
              value: diassem,
              onChanged: (bool? value) {
                setState(() => diassem = value);
              },
            ),
            CheckboxListTile(
              title: const Text('Sábados'),
              value: sabados,
              onChanged: (bool? value) {
                setState(() => sabados = value);
              },
            ),
            CheckboxListTile(
                title: const Text('Domingos'),
                value: domingos,
                onChanged: (bool? value) {
                  setState(() => domingos = value);
                }),
            ElevatedButton(
              onPressed: () {
                print('Nome = ' +
                    nome +
                    " Prioridade = " +
                    prioridade +
                    " Horario = " +
                    horario +
                    " DiasSem =" +
                    diassem.toString() +
                    " Sabados = " +
                    sabados.toString() +
                    " Domingos = " +
                    domingos.toString());
                EnviaDados();
                Navigator.pop;
              },
              child: const Text('Salvar',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> selectTime(BuildContext context) async {
    picked = (await showTimePicker(
      context: context,
      initialTime: _time,
    ))!;
    horario = picked.hour.toString() + ":" + picked.minute.toString();
  }

  void EnviaDados() {
    print('EnviaDados');

    API.getMovie("search").then((response) {
      setState(() {
        print("setState");
        print(response.body);
        // Iterable lista = json.decode(response.body); // Usamos um iterator
      });
    });

    // final Future<Post> post;
    /* final Future<Post>? futureX;

    FutureBuilder<Post>(
      future: futureX,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("TESTE"),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    ); */

    /* Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostDetail(),
      ),
    ); */
  }
}

class API {
  static Future getMovie(search) async {
    String baseUrl = "https://tele-tudo.com";
    // var url = baseUrl + search;
    var url = baseUrl;
    return await http.get(Uri.parse(url));
  }
}

class Tarefas {
  String? Nome;
  int? Prioridade;
  bool? HabDiaSem;
  bool? HamSab;
  bool? HabDom;
  bool? Habilitado;

  Tarefas(
      {this.Nome,
      this.Prioridade,
      this.HabDiaSem,
      this.HamSab,
      this.HabDom,
      this.Habilitado});
}
