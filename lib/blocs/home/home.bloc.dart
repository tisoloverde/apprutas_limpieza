import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:solo_verde/helpers/data.helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:solo_verde/models/geo.model.dart';

import 'package:solo_verde/config/constants.config.dart';
import 'package:solo_verde/config/app.config.dart';
import 'package:solo_verde/services/location.service.dart';

class HomeBloc {
  final privateIsLoading = BehaviorSubject<bool>.seeded(true);
  final privateCurrentPosition = BehaviorSubject<Position>();
  final privateRouteList = BehaviorSubject<List<RoutePlan>>.seeded([]);
  final privatePolylineSet = BehaviorSubject<Set<Polyline>>.seeded({});
  final privateAddress = BehaviorSubject<String>.seeded("");

  Function(bool) get changeIsLoading => privateIsLoading.sink.add;
  Function(Position) get changeCurrentPosition =>
      privateCurrentPosition.sink.add;
  Function(List<RoutePlan>) get changeRouteList => privateRouteList.sink.add;
  Function(Set<Polyline>) get changePolylineSet => privatePolylineSet.sink.add;
  Function(String) get changeAddress => privateAddress.sink.add;

  Stream<bool> get isLoading => privateIsLoading.stream;
  Stream<Position> get currentPosition => privateCurrentPosition.stream;
  Stream<List<RoutePlan>> get lstRoutes => privateRouteList.stream;
  Stream<Set<Polyline>> get setPolyline => privatePolylineSet.stream;
  Stream<String> get address => privateAddress.stream;

  void init() async {
    privateRouteList.value = Data.transformListRoutePlan(AppConstants.routes);
    privatePolylineSet.value = {};
    for (var route in privateRouteList.value) {
      int id = 0;
      for (var coord in route.coords) {
        Polyline polyline = await LocationService.getPolyline(
          "${route.name}_$id",
          Colors.red,
          coord.oLat,
          coord.oLng,
          coord.fLat,
          coord.fLng,
        );
        privatePolylineSet.value.add(polyline);
      }
    }
    privatePolylineSet.value = {...privatePolylineSet.value};
  }

  Position defaultPosition() {
    Position position = Position();
    position.oLat = AppConfig.latDefault;
    position.oLng = AppConfig.lngDefault;
    return position;
  }

  dispose() {
    privateIsLoading.close();
    privateCurrentPosition.close();
    privateRouteList.close();
    privatePolylineSet.close();
    privateAddress.close();
  }
}
