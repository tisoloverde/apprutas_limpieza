class Position {
  late double lat;
  late double lng;

  Position();

  Position.fromJson(Map<String, dynamic> json)
      : lat = json['lat'],
        lng = json['lng'];
}
