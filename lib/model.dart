import 'package:hive_flutter/hive_flutter.dart';

class Model {
  late Box box;

  Future<void> instantiateHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PlayerAdapter());
    await Hive.openBox('myBox');
    box = Hive.box('myBox');
  }

  void saveData() {
    print("SAVING DATA");
    box.put(gameName, playerData);
    print('DONE SAVING DATA');
  }

  List<dynamic> retrievePlayNames() {
    //List<dynamic> playData = box.values.toList();
    List<dynamic> playNames = box.keys.toList();

    return playNames;
  }

  //Player? retrieveData(String key) {
  //  return box.get(key) as Player?;
  //}

  List<Player> getAllData() {
    return box.values.cast<Player>().toList();
  }

  // Private static instance
  static final Model _instance = Model._internal();

  // Private named constructor
  Model._internal();

  // Factory constructor to return the same instance
  factory Model() {
    return _instance;
  }

  late Map<String, Player> playerData = {};
  late String gameName;
  static const Map<String, int> valueOfPlays = {
    'Tri': 10,
    'Dve': 20,
    'Ena': 30,
    'Solo tri': 40,
    'Solo dve': 50,
    'Solo ena': 60,
    'Solo brez': 70,
    'Berač': 70,
    'Barvni valat': 70
  };

  static const Map<String, int> valueOfOther = {
    'Kralji': 10,
    'Napovedani kralji': 10,
    'Trula': 10,
    'Napovedana trula': 10,
    'Kralj ultimo': 10,
    'Napovedan kralj ultimo': 10,
    'Pagat ultimo': 10,
    'Napovedan pagat ultimo': 10,
  };

  void addPlayer(Player player) {
    playerData[player.name] = (player);
  }

  void addPlayerPoints(String playerIdx, int points) {
    playerData[playerIdx]?.points.add(points);
  }

  Map<String, Player> get getPlayerData => playerData;
  Map<String, int> get getValueOfPlays => valueOfPlays;
  Map<String, int> get getValueOfOther => valueOfOther;
  Iterable<String> get getNameOfPlays => valueOfPlays.keys;
  List<String> get getPlayerNames {
    List<String> playerNames = [];
    for (Player player in playerData.values) {
      playerNames.add(player.name);
    }
    return playerNames;
  }

  String get getGameName => gameName;

  void set setGameName(String name) {
    gameName = name;
  }
  // Other methods and logic can go here
}

class Player {
  late String name;
  List<int> points = [0];

  Player(this.name);
}

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 0; // A unique ID for this adapter

  @override
  Player read(BinaryReader reader) {
    // Read the `name` field
    String name = reader.readString();

    // Read the `points` field, which is a list of integers
    List<int> points = reader.readList().cast<int>();

    // Create a Player object and set its fields
    Player player = Player(name);
    player.points = points;

    return player;
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    // Write the `name` field
    writer.writeString(obj.name);

    // Write the `points` field, which is a list of integers
    writer.writeList(obj.points);
  }
}
