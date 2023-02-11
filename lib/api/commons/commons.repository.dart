import 'package:solo_verde/api/commons/commons.service.dart';

import 'package:solo_verde/models/response.model.dart';

import 'package:solo_verde/services/connection.service.dart';

class CommonsRepository {
  CommonsService api = CommonsService();

  Future<ListCommonsRes> listRoutes(
    String comuna,
    String day,
    String time,
  ) async {
    ListCommonsRes response = ListCommonsRes();
    bool hasConnection = await Connection.hasConnection();
    if (hasConnection) {
      response = await api.listRoutes(comuna, day, time);
    } else {
      response.isDisconnected = true;
      response.warning = 'Te encuentras offline';
    }
    return response;
  }
}
