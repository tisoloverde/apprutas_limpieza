import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:solo_verde/extensions.dart';

import 'package:solo_verde/api/commons/commons.repository.dart';

import 'package:solo_verde/models/error.model.dart';
import 'package:solo_verde/models/geo.model.dart';
import 'package:solo_verde/models/response.model.dart';

import 'package:solo_verde/services/location.service.dart';

import 'package:solo_verde/config/app.config.dart';
import 'package:solo_verde/config/constants.config.dart';

import 'package:solo_verde/helpers/functions.helper.dart';
import 'package:solo_verde/helpers/data.helper.dart';

class HomeBloc {
  CommonsRepository repository = CommonsRepository();

  final privateIsLoading = BehaviorSubject<bool>.seeded(true);
  final privateCurrentPosition = BehaviorSubject<Position>();
  final privateRouteList = BehaviorSubject<List<RoutePlan>>.seeded([]);
  final privatePolylineSet = BehaviorSubject<Set<Polyline>>.seeded({});
  final privateMarkerSet = BehaviorSubject<Set<Marker>>.seeded({});
  final privateAddress = BehaviorSubject<String>.seeded("");
  final privateErrorMessage = BehaviorSubject<String>.seeded("");

  Function(bool) get changeIsLoading => privateIsLoading.sink.add;
  Function(Position) get changeCurrentPosition =>
      privateCurrentPosition.sink.add;
  Function(List<RoutePlan>) get changeRouteList => privateRouteList.sink.add;
  Function(Set<Polyline>) get changePolylineSet => privatePolylineSet.sink.add;
  Function(Set<Marker>) get changeMarkerSet => privateMarkerSet.sink.add;
  Function(String) get changeAddress => privateAddress.sink.add;

  Stream<bool> get isLoading => privateIsLoading.stream;
  Stream<Position> get currentPosition => privateCurrentPosition.stream;
  Stream<List<RoutePlan>> get lstRoutes => privateRouteList.stream;
  Stream<Set<Polyline>> get setPolyline => privatePolylineSet.stream;
  Stream<Set<Marker>> get setMarker => privateMarkerSet.stream;
  Stream<String> get address => privateAddress.stream;
  Stream<String> get error => privateErrorMessage.stream;

  void init() async {
    String address = await LocationService.getAddress(
      AppConfig.latDefault,
      AppConfig.lngDefault,
    );
    privateAddress.value = address;

    BitmapDescriptor pinHome = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 1, size: Size(1, 1)),
      'assets/icons/home_location.png',
    );
    BitmapDescriptor pinTarget = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 1, size: Size(1, 1)),
      'assets/icons/target_location.png',
    );

    // privateRouteList.value = Data.transformListRoutePlan(AppConstants.routes);
    privatePolylineSet.value = {};
    privateMarkerSet.value = {};
    for (var route in privateRouteList.value) {
      var pos0 = route.coords[0];
      Marker marker0 = Marker(
        markerId: MarkerId("${route.name}_start"),
        position: LatLng(pos0.oLat, pos0.oLng),
        /*infoWindow: const InfoWindow(title: 'HOTEL', snippet: '5 Star Hotel'),*/
        icon: pinHome,
      );
      privateMarkerSet.value.add(marker0);

      var posf = route.coords[route.coords.length - 1];
      Marker markerf = Marker(
        markerId: MarkerId("${route.name}_finish"),
        position: LatLng(posf.fLat, posf.fLng),
        /*infoWindow: const InfoWindow(title: 'HOTEL', snippet: '5 Star Hotel'),*/
        icon: pinTarget,
      );
      privateMarkerSet.value.add(markerf);

      int id = 0;
      for (var coord in route.coords) {
        Polyline polyline = await LocationService.getPolyline(
          "${route.name}_$id",
          route.color.toColor(),
          coord.oLat,
          coord.oLng,
          coord.fLat,
          coord.fLng,
        );
        id++;
        privatePolylineSet.value.add(polyline);
      }
    }
    privateMarkerSet.value = {...privateMarkerSet.value};
    privatePolylineSet.value = {...privatePolylineSet.value};
  }

  Position defaultPosition() {
    Position position = Position();
    position.oLat = AppConfig.latDefault;
    position.oLng = AppConfig.lngDefault;
    return position;
  }

  getError() => privateErrorMessage.value;

  Future<ListCommonsRes> listRoutes() async {
    privateIsLoading.value = true;

    DateTime now = DateTime.now();
    String time = Functions.onlyTime(now);
    String day = AppConstants.days[DateFormat('EEEE').format(now)] ?? '';

    ListCommonsRes response = await repository.listRoutes(day, time);
    if (response.isDisconnected) {
      privateIsLoading.value = false;
      return response;
    }
    if (response.isTimeout) {
      privateErrorMessage.value = response.error!['error'];
      privateIsLoading.value = false;
      return response;
    }
    if (response.error != null) {
      HttpError error = Data.transformError(response.error);
      privateErrorMessage.value = error.errorDescription ?? error.error;
    } else {
      ApiRes apiRes = ApiRes.fromJson(response.data ?? {});
      privateRouteList.value = Data.transformListRoutePlan(apiRes.aaData);
    }
    privateIsLoading.value = false;

    return response;
  }

  dispose() {
    privateIsLoading.close();
    privateCurrentPosition.close();
    privateRouteList.close();
    privatePolylineSet.close();
    privateAddress.close();
    privateErrorMessage.close();
  }
}
