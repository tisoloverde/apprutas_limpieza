import 'package:dio/dio.dart';

import 'package:solo_verde/api/base/endpoints.repository.dart' as endpoints;

import 'package:solo_verde/models/response.model.dart';

import 'package:solo_verde/helpers/http.helper.dart';

class CommonsService {
  HttpRequest http = HttpRequest();

  Future<ListCommonsRes> listRoutes(
    String comuna,
    String day,
    String time,
    String? coordCurrent,
  ) async {
    ListCommonsRes response = ListCommonsRes();
    String url = endpoints.commons.routes;
    Map<String, dynamic> data = {
      "comuna": comuna,
      "day": day,
      "time": time,
      "coordCurrent": coordCurrent,
    };

    await http.postEncodedHttp(url, data).then((res) {
      Map<String, dynamic> resData = {"data": res.data};
      response = ListCommonsRes.fromJson(resData);
    }).catchError((e) {
      if (e is DioError) {
        final err = http.handleError(e, '');
        response.isTimeout = err.isTimeout;
        response.error = {"error": err.msg};
      } else {
        response.error = {"error": "¡Ocurrió un error interno!"};
      }
    });

    return response;
  }
}
