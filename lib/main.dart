import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.pacifico(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          labelLarge: GoogleFonts.pacifico(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 50,
                width: 100,
              ),
              Text('Tarok', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(
                height: 200,
                width: 100,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GameStart()));
                  },
                  child: const Text('Nova igra')),
              ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Not implemeted yet!!!"),
                    ));
                  },
                  child: const Text('Naloži igro')),
              const Spacer(),
            ],
          ),
        ),
      ),
      //floatingActionButton: FloatingActionButton(
      //  tooltip: 'Increment',
      //  child: const Icon(Icons.add),
      //), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class GameStart extends StatefulWidget {
  const GameStart({super.key});

  @override
  State<GameStart> createState() => _GameStartState();
}

class _GameStartState extends State<GameStart> {
  Model config = Model();
  TextEditingController playerInputController = TextEditingController();
  TextEditingController gameNameInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova igra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Ime igre'),
              ),
              controller: gameNameInputController,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Ime novega igralca'),
                  ),
                  controller: playerInputController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (playerInputController.text.isNotEmpty) {
                        if (config.getPlayerNames
                            .contains(playerInputController.text)) {
                          showToast(
                              context, "Igralec s tem imenom že obstaja!");
                        } else {
                          config.addPlayer(Player(playerInputController.text));
                          playerInputController.clear();
                        }
                      } else {
                        showToast(context, "Vpiši ime igralca!");
                      }
                    });
                  },
                  child: const Text('Dodaj'),
                ),
              ),
            ]),
            const Text("Igralci"),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(
                  children: [
                    for (String name in config.getPlayerNames)
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(name),
                        dense: true,
                        iconColor: Colors.lightBlueAccent,
                        onTap: () {
                          showToast(
                              context, "Spremembe igralcev še niso na voljo!");
                        },
                      )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (gameNameInputController.text.isNotEmpty &&
                            config.getPlayerData.isNotEmpty) {
                          config.gameName = gameNameInputController.text;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainGameScreen()));
                        } else {
                          showToast(context, "Vpiši ime igre!");
                        }
                      });
                    },
                    child: const Text('Začni igro'))
              ],
            )
          ],
        ),
      ),
      //floatingActionButton: FloatingActionButton(
      //  tooltip: 'Increment',
      //  child: const Icon(Icons.add),
      //), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void showToast(BuildContext context, String message) {
    var toast = ScaffoldMessenger.of(context);
    toast.showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(label: 'OK', onPressed: toast.hideCurrentSnackBar),
    ));
  }
}

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  Model config = Model();

  void transformData() {
    List<List<int>> rowsFirst = [];
    bool stillFull = true;
    int i = 0;
    while (stillFull) {
      stillFull = false;
      rowsFirst.add([]);
      for (var player in config.getPlayerData) {
        if (i < player.points.length - 1) {
          rowsFirst.lastOrNull!.add(player.points[i]);
          stillFull = true;
        }
      }
      i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(config.getGameName),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      for (String name in config.getPlayerNames)
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(name,
                                style: Theme.of(context).textTheme.labelLarge),
                          ),
                        ),
                    ]),
                  ],
                ),
              ),
              Spacer(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => MyApp()));
                        },
                        child: Icon(Icons.home)),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewPlay()));
                        },
                        child: Icon(Icons.add)),
                  ])
            ],
          ),
        ));
  }
}

class NewPlay extends StatefulWidget {
  const NewPlay({super.key});

  @override
  State<NewPlay> createState() => _NewPlayState();
}

class _NewPlayState extends State<NewPlay> {
  Model config = Model();
  List<int> results = List.filled(9, 0);
  String partner = '';
  /*
  0 - razlika
  1 - igra
  2 - kralji
  3 - napovedani kralji
  4 - trula
  5 - napovedana trula
  6 - kralj ultimo
  7 - napovedani kralj ultimo
  8 - pagat ultimo
  9 - napovedani pagat ultimo
  */

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Vpiši igro"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          decoration: new InputDecoration(labelText: "Razlika"),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) {
                            setState(() {
                              if (value != '') {
                                results[0] = int.parse(value);
                              } else {
                                results[0] = 0;
                              }
                            });
                          }, // Only numbers can be entered
                        ),
                      ),
                      SwitchSign(
                        onChanged: (value) {
                          setState(() {
                            results[0] *= (value ? 1 : -1);
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                    height: 50,
                  ),
                  Row(
                    children: [
                      Text("Igra:"),
                      SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      DropdownButtonExample(
                        dropdownMenu: config.getNameOfPlays.toList(),
                        onChanged: (value) {
                          setState(() {
                            results[1] = config.getValueOfPlays[value]!;
                          });
                        },
                      ),
                      SizedBox(
                        width: 50,
                        height: 10,
                      ),
                      Text("Partner:"),
                      SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      DropdownButtonExample(
                        dropdownMenu: config.getPlayerNames,
                        onChanged: (value) {
                          partner = value;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                    height: 50,
                  ),
                  CheckboxCluster(
                    onChanged: (value) {
                      setState(() {
                        for (int i = 2; i < results.length; i++) {
                          results[i] = value[i - 2] * 10;
                        }
                      });
                    },
                  ),
                  //Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text('Skupna vsota:   ',
                          style: Theme.of(context).textTheme.labelLarge),
                      Text(
                          results
                              .reduce((value, element) => value + element)
                              .toString(),
                          style: Theme.of(context).textTheme.labelLarge),
                      Spacer(),
                    ],
                  ),
                  //Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        print('Here');
                      },
                      child: Text('Dodaj')),
                ],
              ),
            )));
  }
}

class DropdownButtonExample extends StatefulWidget {
  final List<String> dropdownMenu;
  final Function(String) onChanged;

  const DropdownButtonExample(
      {Key? key, required this.dropdownMenu, required this.onChanged})
      : super(key: key);

  @override
  State<DropdownButtonExample> createState() =>
      _DropdownButtonExampleState(dropdownMenu);
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  late List<String> dropdownMenu;
  Model config = Model();
  String dropdownValue = '';

  _DropdownButtonExampleState(var dropdownData) {
    dropdownData.add("Solo");
    dropdownMenu = dropdownData;
    dropdownValue = dropdownData.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          widget.onChanged(dropdownValue);
        });
      },
      items: dropdownMenu.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class SwitchSign extends StatefulWidget {
  const SwitchSign({Key? key, required this.onChanged});
  final Function(bool) onChanged;
  @override
  State<SwitchSign> createState() => _SwitchSignState();
}

class _SwitchSignState extends State<SwitchSign> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: true,
      activeColor: Colors.green,
      inactiveTrackColor: Colors.red,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          widget.onChanged(value);
        });
      },
    );
  }
}

class CheckboxCluster extends StatefulWidget {
  const CheckboxCluster({Key? key, required this.onChanged}) : super(key: key);
  final Function(List<int>) onChanged;

  @override
  State<CheckboxCluster> createState() => _CheckboxClusterState();
}

class _CheckboxClusterState extends State<CheckboxCluster> {
  bool isChecked = false;
  List<int> addings = List.filled(8, 0);
  /*
  bool kralji = false;
  bool napovedani_kralji = false;
  bool trula = false;
  bool napovedana_trula = false;
  bool kralj_ultima = false;
  bool napovedani_kralj_ultima = false;
  bool pagat_ultima = false;
  bool napovedan_pagat_ultima = false;
  */

  Checkbox checkboxParams(adding_index) {
    return Checkbox(
        checkColor: Colors.white,
        activeColor: Colors.purple.shade400,
        value: false,
        onChanged: (bool? value) {
          setState(() {
            addings[adding_index] = (value! ? 1 : 0);
            print('Addings are:' + addings.toString());
            widget.onChanged(addings);
          });
        });
  }

  Widget build(BuildContext context) {
    return Table(children: [
      TableRow(
        children: [
          Text(" "),
          Text("Predznak"),
          Text("Opravljeno"),
          Text('Napovedano'),
        ],
      ),
      TableRow(children: [
        Text('Kralji:'),
        SwitchSign(
          onChanged: (value) {
            //print("Value is:" + value.toString());
            //print("Addings is:" + addings.toString());
            //addings[0] = addings[0] * (value ? 1 : -1);
            //addings[1] = addings[1] * (value ? 1 : -1);
            //print("Value is:" + value.toString());
            //print("Addings is:" + addings.toString());
          },
        ),
        checkboxParams(0),
        checkboxParams(1),
      ]),
      TableRow(children: [
        Text('Trula:'),
        SwitchSign(
          onChanged: (value) {
            //addings[2] *= (value ? 1 : -1);
            //addings[3] *= (value ? 1 : -1);
          },
        ),
        checkboxParams(2),
        checkboxParams(3),
      ]),
      TableRow(children: [
        Text('Kralj ultimo:'),
        SwitchSign(
          onChanged: (value) {
            //addings[4] *= (value ? 1 : -1);
            //addings[5] *= (value ? 1 : -1);
          },
        ),
        checkboxParams(4),
        checkboxParams(5),
      ]),
      TableRow(children: [
        Text('Pagat ultimo:'),
        SwitchSign(
          onChanged: (value) {
            //addings[6] *= (value ? 1 : -1);
            //addings[7] *= (value ? 1 : -1);
          },
        ),
        checkboxParams(6),
        checkboxParams(7),
      ]),
    ]);
  }
}
