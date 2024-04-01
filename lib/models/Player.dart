class Player {
  final String username;
  final String deviceID;

  Player({
    required this.username,
    required this.deviceID
  });

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['username'] = username;
    m['deviceID'] = deviceID;

    return m;
  }
}