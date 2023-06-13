import 'package:dio/dio.dart';

import 'package:solo_verde/config/app.config.dart';
import 'package:solo_verde/models/error.model.dart';

class HttpRequest {
  late Dio dio;
  HttpRequest() {
    BaseOptions options = BaseOptions(
      // baseUrl: "your base url",
      receiveDataWhenStatusError: true,
      connectTimeout: AppConfig.timeout * 1000, // 60 seconds
      receiveTimeout: AppConfig.timeout * 1000, // 60 seconds
    );
    dio = Dio(options);
  }

  Future getHttp(String url) async {
    final response = await dio.get(url);
    return response;
  }

  Future postEncodedHttp(String url, Map<String, dynamic> data) async {
    String encodedBody =
        data.keys.map((String key) => "$key=${data[key]}").join("&");
    Options options =
        Options(headers: {'content-type': 'application/x-www-form-urlencoded'});
    final response = await dio.post(url, data: encodedBody, options: options);
    return response;
  }

  ResponseError handleError(DioError e, String entity, {int? id}) {
    bool isTimeout = true;
    String msg = '';
    switch (e.type) {
      case DioErrorType.connectTimeout:
        msg += "¡Tiempo de conexión al servidor agotado!";
        break;
      case DioErrorType.receiveTimeout:
        msg += "¡Tiempo de espera agotado del servidor!";
        break;
      default:
        isTimeout = false;
        if (e.response != null) {
          if (e.response!.data['Message'] != null) {
            if (e.response!.data['ExceptionMessage'] != null) {
              final err = e.response!.data['ExceptionMessage'];
              msg += "$err";
            } else {
              msg += e.response!.data['Message'];
            }
          } else if (e.response!.data['error_description'] != null) {
            msg = e.response!.data['error_description'];
          }
        } else {
          msg += '¡No se puede conectar al servidor!';
        }
        break;
    }
    return ResponseError(isTimeout, msg);
  }
}
