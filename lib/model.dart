import 'package:hive_flutter/hive_flutter.dart';

class Model {
  late Box box;
  late Map<String, Player> playerData = {};
  late String gameName;

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

  void deletePlay(var nameOfPlay) {
    box.delete(nameOfPlay);
  }

  void retrievePlay(var nameOfPlay) {
    gameName = nameOfPlay;
    playerData = Map<String, Player>.from(box.get(nameOfPlay) as Map);
    print("GAME NAME>" + gameName);
    print("PlayerData>" + playerData.toString());
  }

  // Private static instance
  static final Model _instance = Model._internal();

  // Private named constructor
  Model._internal();

  // Factory constructor to return the same instance
  factory Model() {
    return _instance;
  }

  static const Map<String, int> valueOfPlays = {
    'Tri': 10,
    'Dve': 20,
    'Ena': 30,
    'Solo tri': 40,
    'Solo dve': 50,
    'Solo ena': 60,
    'Solo brez': 70,
    'Berač': 70,
    'Barvni valat': 70,
    'Klop': 0,
  };

  static const Map<String, String> playAbbreviations = {
    'Tri': '3',
    'Dve': '2',
    'Ena': '1',
    'Solo tri': 'S3',
    'Solo dve': 'S2',
    'Solo ena': 'S1',
    'Solo brez': 'SB',
    'Berač': 'B',
    'Barvni valat': 'BV',
    'Klop': 'K',
    'None': ''
  };

  // static const List<String> radelciOfPlays = [
  //   'Solo brez',
  //   'Berač',
  //   'Barvni valat',
  //   'Klop'
  // ];

  // static const Map<String, int> valueOfOther = {
  //   'Kralji': 10,
  //   'Napovedani kralji': 10,
  //   'Trula': 10,
  //   'Napovedana trula': 10,
  //   'Kralj ultimo': 10,
  //   'Napovedan kralj ultimo': 10,
  //   'Pagat ultimo': 10,
  //   'Napovedan pagat ultimo': 10,
  // };

  void addPlayer(Player player) {
    playerData[player.name] = (player);
  }

  void addPlayerPoints(String playerName, int points) {
    playerData[playerName]?.points.add(points);
  }

  void addPlayerPlay(String playerName, String game) {
    String? name = playAbbreviations[game];
    if (name != null) {
      playerData[playerName]?.nameOfPlayed.add(name);
    } else {
      throw Exception('Game name does not exists in name of abbreviations!');
    }
  }

  void addRadelce() {
    for (Player player in playerData.values) {
      player.radelci.add(false);
    }
  }

  bool hasRadelc(String playerName) {
    var player = playerData[playerName];
    if (player != null) {
      for (bool el in player.radelci) {
        if (el == false) {
          return true;
        }
      }
      return false;
    } else {
      throw Exception("Player with this name does not exists");
    }
  }

  Map<String, Player> get getPlayerData => playerData;
  Map<String, int> get getValueOfPlays => valueOfPlays;
  Map<String, String> get getplayAbbreviations => playAbbreviations;
  Iterable<String> get getNameOfPlays => valueOfPlays.keys;
  // List<String> get getRadelciOfPlays => radelciOfPlays;
  // Map<String, int> get getValueOfOther => valueOfOther;

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
  @HiveField(0)
  late String name;

  @HiveField(1)
  List<int> points = [0];

  @HiveField(2)
  List<bool> radelci = [];

  @HiveField(3)
  List<String> nameOfPlayed = [];

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

    List<bool> radelci = reader.readList().cast<bool>();
    List<String> nameOfPlayed = reader.readList().cast<String>();

    // Create a Player object and set its fields
    Player player = Player(name);
    player.points = points;
    player.radelci = radelci;
    player.nameOfPlayed = nameOfPlayed;

    return player;
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    // Write the `name` field
    writer.writeString(obj.name);

    // Write the `points` field, which is a list of integers
    writer.writeList(obj.points);

    writer.writeList(obj.radelci);

    writer.writeList(obj.nameOfPlayed);
  }
}
