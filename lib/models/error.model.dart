class HttpError {
  late String error;
  late String? errorDescription;

  HttpError();

  HttpError.fromJson(Map<String, dynamic> json)
      : error = json['error'],
        errorDescription = json['error_description'];
}
