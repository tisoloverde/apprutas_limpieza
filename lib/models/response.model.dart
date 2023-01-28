class ApiRes {
  late int sEcho;
  late int iTotalRecords;
  late int iTotalDisplayRecords;
  late List<dynamic> aaData;

  ApiRes();

  ApiRes.fromJson(Map<String, dynamic> json)
      : sEcho = json['sEcho'],
        iTotalRecords = json['iTotalRecords'],
        iTotalDisplayRecords = json['iTotalDisplayRecords'],
        aaData = json['aaData'];
}

class ListCommonsRes {
  String? warning;
  bool isDisconnected = false;
  bool isTimeout = false;
  late Map<String, dynamic>? error = {};
  late Map<String, dynamic>? data = {};

  ListCommonsRes();

  ListCommonsRes.fromJson(Map<String, dynamic> json)
      : error = json['error'],
        data = json['data'];
}
