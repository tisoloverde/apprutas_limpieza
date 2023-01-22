import 'package:rxdart/rxdart.dart';
import 'package:solo_verde/helpers/data.helper.dart';

import 'package:solo_verde/models/geo.model.dart';

import 'package:solo_verde/config/constants.config.dart';
import 'package:solo_verde/config/app.config.dart';

class HomeBloc {
  final privateIsLoading = BehaviorSubject<bool>.seeded(true);
  final privateCurrentPosition = BehaviorSubject<Position>();
  final privateRouteList = BehaviorSubject<List<RoutePlan>>.seeded([]);

  Function(bool) get changeIsLoading => privateIsLoading.sink.add;
  Function(Position) get changeCurrentPosition =>
      privateCurrentPosition.sink.add;
  Function(List<RoutePlan>) get changeRouteList => privateRouteList.sink.add;

  Stream<bool> get isLoading => privateIsLoading.stream;
  Stream<Position> get currentPosition => privateCurrentPosition.stream;
  Stream<List<RoutePlan>> get lstRoutes => privateRouteList.stream;

  void init() {
    privateRouteList.value = Data.transformListRoutePlan(AppConstants.routes);
  }

  Position defaultPosition() {
    Position position = Position();
    position.lat = AppConfig.latDefault;
    position.lng = AppConfig.lngDefault;
    return position;
  }

  dispose() {
    privateIsLoading.close();
    privateCurrentPosition.close();
  }
}
