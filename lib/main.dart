import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

class Player {
  late String name;
  List<int> points = [0];

  Player(this.name);
}

class GameStart extends StatefulWidget {
  const GameStart({super.key});

  @override
  State<GameStart> createState() => _GameStartState();
}

class _GameStartState extends State<GameStart> {
  List<Player> allPlayers = [];

  @override
  Widget build(BuildContext context) {
    TextEditingController playerInputController = TextEditingController();
    TextEditingController gameNameInputController = TextEditingController();
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
                        allPlayers.add(Player(playerInputController.text));
                        playerInputController.clear();
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
                    for (Player pl in allPlayers)
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(pl.name),
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
                      showToast(context, "Igra se začenja!");
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
