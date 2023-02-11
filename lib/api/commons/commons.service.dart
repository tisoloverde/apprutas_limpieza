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
  ) async {
    ListCommonsRes response = ListCommonsRes();
    String url = endpoints.commons.routes;
    Map<String, dynamic> data = {"comuna": comuna, "day": day, "time": time};

    await http.postEncodedHttp(url, data).then((res) {
      Map<String, dynamic> resData = {"data": res.data};
      response = ListCommonsRes.fromJson(resData);
    }).catchError((e) {
      if (e is DioError && e.type == DioErrorType.connectTimeout) {
        response.isTimeout = true;
        response.error = {"error": '¡No se puede conectar al servidor!'};
      } else {
        response.error = e.response.data;
      }
    });

    return response;
  }
}
