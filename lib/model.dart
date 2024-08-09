class Model {
  // Private static instance
  static final Model _instance = Model._internal();

  // Private named constructor
  Model._internal();

  // Factory constructor to return the same instance
  factory Model() {
    return _instance;
  }

  late List<Player> playerData = [];
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

  void addPlayer(Player player) {
    playerData.add(player);
  }

  List<Player> get getPlayerData => playerData;
  Map<String, int> get getValueOfPlays => valueOfPlays;
  Iterable<String> get getNameOfPlays => valueOfPlays.keys;
  List<String> get getPlayerNames {
    List<String> playerNames = [];
    for (Player player in playerData) {
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
