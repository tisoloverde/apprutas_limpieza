import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String env = dotenv.env['DART_ENV'] ?? 'development';
  static int timerLogoInit = 1;
  static bool debugTagSimulator = dotenv.env['DART_ENV'] != 'production';
  static String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:5000';
  static String ctxUrl = dotenv.env['API_CTX'] ?? 'api/v1';
  static int timeout = int.parse(dotenv.env['API_TIMEOUT'] ?? '20'); // seconds
  static String language = dotenv.env['LANGUAGE'] ?? 'es';
  static double latDefault =
      double.parse(dotenv.env['LATITUDE_DEFAULT'] ?? '0');
  static double lngDefault =
      double.parse(dotenv.env['LONGITUDE_DEFAULT'] ?? '0');
  static String googleMapsKey = dotenv.env['GOOGLE_MAPS_KEY'] ?? '';
  static String googleMapsApi = dotenv.env['GOOGLE_MAPS_API'] ??
      'https://maps.googleapis.com/maps/api/place';
}
