import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'model.dart';
import 'guiControll.dart';

void main() async {
  Model config = Model();
  await config.instantiateHive();

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
  Model config = Model();

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = config.retrievePlayNames();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 50,
                width: 100,
              ),
              Text('Tarok', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(
                height: 100,
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
              SizedBox(
                height: 100,
                width: 10,
              ),
              Text("Shranjene igre:"),
              Expanded(
                child: ListView(
                  children: [
                    for (var name in data)
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                                width: 5, color: Colors.purple.shade200)),
                        child: ListTile(
                          leading: Icon(Icons.games),
                          title: Text(name,
                              style: Theme.of(context).textTheme.bodyMedium),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  config.retrievePlay(name);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MainGameScreen()));
                                },
                                icon: Icon(Icons.play_arrow),
                                color: Colors.green,
                              ),
                              IconButton(
                                onPressed: () => showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('OPOZORILO'),
                                    content: const Text(
                                        'Želite nepovratno izbrisati igro?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Prekliči'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            config.deletePlay(name);
                                            Navigator.pop(context, 'Izbriši');
                                          });
                                        },
                                        child: const Text('Izbriši'),
                                      ),
                                    ],
                                  ),
                                ),
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                  //floatingActionButton: FloatingActionButton(
                  //  tooltip: 'Increment',
                  //  child: const Icon(Icons.add),
                  //), // This trailing comma makes auto-formatting nicer for build methods.
                ),
              ),
            ],
          ),
        ),
      ),
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
                          config.saveData();
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
}

class MainGameScreen extends StatefulWidget {
  const MainGameScreen({super.key});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  Model config = Model();

  List<List<int?>> transformData() {
    List<List<int?>> rowsFirst = [];
    bool stillFull = true;
    int row = 1;
    while (stillFull) {
      stillFull = false;
      rowsFirst.add([]);
      int col = 0;
      for (var player in config.getPlayerData.values) {
        print("Player: " +
            player.name +
            "     |||    Player Data values " +
            player.points.toString());
        if (row < player.points.length) {
          print("FirstPoints: " +
              player.points[row - 1].toString() +
              "     |||    SecondPOints " +
              player.points[row].toString());
          print(rowsFirst);
          if (row > 1) {
            print((row - 1).toString() + '    ' + col.toString());
            rowsFirst.lastOrNull!
                .add(rowsFirst[row - 2][col]! + player.points[row]);
          } else {
            rowsFirst.lastOrNull!.add(player.points[row]);
          }
          stillFull = true;
        } else {
          rowsFirst.lastOrNull!.add(null);
        }
        col += 1;
      }
      row++;
    }
    print("ROWS FIRST>>>>" + rowsFirst.toString());
    return rowsFirst;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Table(
                  border: TableBorder.all(color: Colors.purple),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  children: [
                    TableRow(children: [
                      for (String name in config.getPlayerNames)
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(name,
                                style: Theme.of(context).textTheme.labelLarge),
                          ),
                        ),
                    ]),
                    TableRow(children: [
                      for (String name in config.getPlayerNames)
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Row(children: [
                            for (bool radelc
                                in config.getPlayerData[name]!.radelci)
                              radelc == true
                                  ? Icon(Icons.circle_rounded)
                                  : Icon(Icons.circle_outlined),
                          ]),
                        ),
                    ]),
                    for (List<int?> point in transformData())
                      TableRow(children: [
                        for (int? p in point)
                          if (p == null)
                            Container()
                          else
                            Center(child: Text(p.toString())),
                        //Padding(
                        //padding: const EdgeInsets.all(8.0),
                        //child: Text(name,
                        //style: Theme.of(context).textTheme.labelLarge),
                        //),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewPlay()),
                          ).then((result) {
                            setState(() {
                              print("UPDATING STATE");
                            });
                          });
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
  String igralec = '';
  bool addRadelce = false;
  bool useRadelc = false;
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

  int calculateResults(bool radelc) {
    int out = results.reduce((value, element) => value + element);
    if (radelc) {
      return out * 2;
    } else {
      return out;
    }
  }

  @override
  void initState() {
    partner = 'Brez';
    results[0] = 0;
    igralec = config.getPlayerNames.last;
    print("USING INIT STATE!");
    super.initState();
  }

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: TextField(
                            decoration: new InputDecoration(labelText: "Točke"),
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
                              results[0] *= -1;
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
                            //setState(() {
                            //  results[1] = config.getValueOfPlays[value]!;
                            //});
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Igralec:"),
                        SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        DropdownButtonExample(
                          dropdownMenu: config.getPlayerNames,
                          onChanged: (value) {
                            setState(() {
                              print("HERE    " + value);
                              igralec = value;
                              print("IGRALEC    " + igralec);
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Partner:"),
                        SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        DropdownButtonExample(
                          dropdownMenu: config.getPlayerNames + ["Brez"],
                          onChanged: (value) {
                            partner = value;
                          },
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Text("Dodaj vsem radelce:"),
                        SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.purple.shade400,
                            value: addRadelce,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value != null) {
                                  addRadelce = value;
                                }
                              });
                            }),
                      ],
                    ),

                    Row(
                      children: [
                        Text("Porabi radelc:"),
                        SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.purple.shade400,
                            value: useRadelc,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value != null) {
                                  print(igralec);
                                  if (config.hasRadelc(igralec)) {
                                    useRadelc = value;
                                  } else {
                                    showToast(context,
                                        "Igralec je porabil že vse radelce");
                                  }
                                }
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                      height: 50,
                    ),

                    /*
                  CheckboxCluster(onChanged: (addings, switchSigns) {
                    print(addings);
                    print(switchSigns);
                    setState(() {
                      //CALCULATE!!!
                      //    print(value);
                      //for (int i = 2; i < results.length; i++) {
                      //  results[i] = value[i - 2] * 10;
                    });
                  }),*/
                    //Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text('Skupna vsota:   ',
                            style: Theme.of(context).textTheme.labelLarge),
                        Text(calculateResults(useRadelc).toString(),
                            style: Theme.of(context).textTheme.labelLarge),
                        Spacer(),
                      ],
                    ),
                    //Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            config.addPlayerPoints(
                                igralec, calculateResults(useRadelc));
                            config.addPlayerPoints(
                                partner, calculateResults(useRadelc));
                            if (useRadelc) {
                              Player pl = config.playerData[igralec]!;
                              for (final (index, item) in pl.radelci.indexed) {
                                if (item == false) {
                                  config.playerData[igralec]!.radelci[index] =
                                      true;
                                  break;
                                }
                              }
                            }

                            if (addRadelce) {
                              config.addRadelce();
                            }
                            config.saveData();
                            Navigator.pop(context);
                          });
                        },
                        child: Text('Dodaj')),
                  ]),
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
    dropdownMenu = dropdownData;
    dropdownValue = dropdownData.last;
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
  bool stat = true;
  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: stat,
      activeColor: Colors.green,
      inactiveTrackColor: Colors.red,
      onChanged: (bool value) {
        setState(() {
          stat = value;
          widget.onChanged(value);
        });
        // This is called when the user toggles the switch.
//        setState(() {
//          print(
//              "#############################################################");
        //
//        });
      },
    );
  }
}

class CheckboxCluster extends StatefulWidget {
  const CheckboxCluster({Key? key, required this.onChanged}) : super(key: key);
  final Function(List<bool>, List<bool>) onChanged;

  @override
  State<CheckboxCluster> createState() => _CheckboxClusterState();
}

class _CheckboxClusterState extends State<CheckboxCluster> {
  //bool? isChecked = false;
  List<bool> addings = List.filled(8, false);
  List<bool> switchSign = List.filled(4, true);
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
        value: addings[adding_index],
        onChanged: (bool? value) {
          setState(() {
            if (value != null) {
              addings[adding_index] = value;
              widget.onChanged(addings, switchSign);
            }
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
            switchSign[0] = value;
            // print("Value is:" + value.toString());
            // print("Addings is:" + addings.toString());
            // addings[0] = addings[0] * (value ? 1 : -1);
            // addings[1] = addings[1] * (value ? 1 : -1);
            // print("Value is:" + value.toString());
            // print("Addings is:" + addings.toString());
          },
        ),
        checkboxParams(0),
        checkboxParams(1),
      ]),
      TableRow(children: [
        Text('Trula:'),
        SwitchSign(
          onChanged: (value) {
            switchSign[1] = value;
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
            switchSign[2] = value;
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
            switchSign[3] = value;
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
