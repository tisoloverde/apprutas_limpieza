import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:solo_verde/extensions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  final privateIsInit = BehaviorSubject<bool>.seeded(true);
  final privateIsLoading = BehaviorSubject<bool>.seeded(true);
  final privateCurrentPosition = BehaviorSubject<Position?>.seeded(null);
  final privateRouteList = BehaviorSubject<List<RoutePlan>>.seeded([]);
  final privatePolylineSet = BehaviorSubject<Set<Polyline>>.seeded({});
  final privateAddress = BehaviorSubject<String>.seeded("");
  final privateErrorMessage = BehaviorSubject<String>.seeded("");

  Function(bool) get changeIsInit => privateIsInit.sink.add;
  Function(bool) get changeIsLoading => privateIsLoading.sink.add;
  Function(Position?) get changeCurrentPosition =>
      privateCurrentPosition.sink.add;
  Function(List<RoutePlan>) get changeRouteList => privateRouteList.sink.add;
  Function(Set<Polyline>) get changePolylineSet => privatePolylineSet.sink.add;
  Function(String) get changeAddress => privateAddress.sink.add;

  Stream<bool> get isInit => privateIsInit.stream;
  Stream<bool> get isLoading => privateIsLoading.stream;
  Stream<Position?> get currentPosition => privateCurrentPosition.stream;
  Stream<List<RoutePlan>> get lstRoutes => privateRouteList.stream;
  Stream<Set<Polyline>> get setPolyline => privatePolylineSet.stream;
  Stream<String> get address => privateAddress.stream;
  Stream<String> get error => privateErrorMessage.stream;

  Future<void> getAddressAndComuna(double lat, double lng) async {
    List<String> addresses = await LocationService.getAddress(lat, lng);
    privateAddress.value = addresses[0];
    await listRoutes(addresses[1]);
    await viewRoutes();
  }

  Future<void> viewRoutes() async {
    final routeList = getOnlyCloserRoutes(privateRouteList.value);
    privatePolylineSet.value = {};
    for (var route in routeList) {
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
    privatePolylineSet.value = {...privatePolylineSet.value};
  }

  Position defaultPosition() {
    Position position = Position();
    position.oLat = AppConfig.latDefault;
    position.oLng = AppConfig.lngDefault;
    return position;
  }

  getAddress() => privateAddress.value;
  getError() => privateErrorMessage.value;
  getCurrentPosition() => privateCurrentPosition.value;

  Future<ListCommonsRes> listRoutes(String comuna) async {
    DateTime now = DateTime.now();
    String time = Functions.onlyTime(now);
    String day = AppConstants.days[DateFormat('EEEE').format(now)] ?? '';
    String? coordCurrent = privateCurrentPosition.value?.toCoordStr();

    ListCommonsRes response = await repository.listRoutes(
      comuna,
      day,
      time,
      coordCurrent,
    );
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
      privateIsLoading.value = false;
      HttpError error = Data.transformError(response.error);
      privateErrorMessage.value = error.errorDescription ?? error.error;
    }

    ApiRes apiRes = ApiRes.fromJson(response.data ?? {});
    privateRouteList.value = Data.transformListRoutePlan(apiRes.aaData);

    return response;
  }

  void selectRouteToView(int index) {
    for (int i = 0; i < privateRouteList.value.length; i++) {
      privateRouteList.value[i].isCloser = false;
    }
    privateRouteList.value[index].isCloser = true;
    privateRouteList.value = [...privateRouteList.value];
  }

  List<RoutePlan> getOnlyCloserRoutes(List<RoutePlan> routes) {
    List<RoutePlan> res = [];
    for (var item in routes) {
      if (item.isCloser) res.add(item);
    }
    return res;
  }

  dispose() {
    privateIsInit.close();
    privateIsLoading.close();
    privateCurrentPosition.close();
    privateRouteList.close();
    privatePolylineSet.close();
    privateAddress.close();
    privateErrorMessage.close();
  }
}
