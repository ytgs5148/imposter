class Player {
  final String username;
  final String deviceID;
  final String? votedFor;

  Player({
    required this.username,
    required this.deviceID,
    this.votedFor
  });

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['username'] = username;
    m['deviceID'] = deviceID;
    m['votedFor'] = votedFor;

    return m;
  }

  static fromJSON(Map<String, dynamic> json) {
    return Player(
      username: json['username'],
      deviceID: json['deviceID'],
      votedFor: json['votedFor']
    );
  }
}