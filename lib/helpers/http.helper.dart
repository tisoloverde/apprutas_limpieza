import 'package:dio/dio.dart';

import 'package:solo_verde/config/app.config.dart';

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
}
