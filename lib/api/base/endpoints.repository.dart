import 'package:solo_verde/config/app.config.dart';

final String api = "${AppConfig.apiUrl}/${AppConfig.ctxUrl}";

class Commons {
  final routes = '$api/listarRutas.php';
}

final commons = Commons();
