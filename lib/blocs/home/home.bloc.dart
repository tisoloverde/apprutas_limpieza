import 'package:rxdart/rxdart.dart';

import 'package:solo_verde/models/geo.model.dart';

import 'package:solo_verde/config/app.config.dart';

class HomeBloc {
  final privateIsLoading = BehaviorSubject<bool>.seeded(true);
  final privateCurrentPosition = BehaviorSubject<Position>();

  Function(bool) get changeIsLoading => privateIsLoading.sink.add;
  Function(Position) get changeCurrentPosition =>
      privateCurrentPosition.sink.add;

  Stream<bool> get isLoading => privateIsLoading.stream;
  Stream<Position> get currentPosition => privateCurrentPosition.stream;

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
