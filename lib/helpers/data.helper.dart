import 'package:solo_verde/models/error.model.dart';
import 'package:solo_verde/models/geo.model.dart';

class Data {
  static HttpError transformError(var data) {
    HttpError res = HttpError.fromJson(data);
    return res;
  }

  static List<Position> transformListPosition(var data) {
    if (data == null) return [];
    List<Position> lst = (data as List)
        .map<Position>((item) => Position.fromJson(item))
        .toList();
    return lst;
  }

  static List<String> transformListDay(var data) {
    if (data == null) return [];
    List<String> lst = (data as List).map<String>((item) => item).toList();
    return lst;
  }

  static List<RoutePlan> transformListRoutePlan(var data) {
    if (data == null) return [];
    List<RoutePlan> lst = (data as List)
        .map<RoutePlan>((item) => RoutePlan.fromJson(item))
        .toList();
    return lst;
  }
}
