import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solo_verde/config/app.config.dart';

import 'package:solo_verde/services/location.service.dart';

import 'package:solo_verde/blocs/home/home.bloc.dart';

import 'package:solo_verde/models/geo.model.dart';

import 'package:solo_verde/widgets/loading_app.dart';
import 'package:solo_verde/widgets/stream_input_text.dart';

import 'package:solo_verde/helpers/functions.helper.dart';

import 'package:solo_verde/values/colors.dart' as colors;
import 'package:solo_verde/values/dimens.dart' as dimens;

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool _isInit = true;
  final double _height = 320;
  final double _zoom = 15; // 19.151926040649414;
  Timer? _timer;

  HomeBloc _bloc = HomeBloc();
  final _controller = Completer<GoogleMapController>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) return;
    setState(() => _isInit = false);
    _bloc = Provider.of<HomeBloc>(context);
    // _init();
  }

  @override
  void initState() {
    super.initState();
    LocationService.currentLocation().then((value) {
      _bloc.changeCurrentPosition(Position.fromJson(value));
    });
    _timer = Timer.periodic(
      Duration(seconds: AppConfig.periodic),
      (Timer t) => _init(),
    );
  }

  void _init() {
    _bloc.listRoutes().then((value) {
      if (value.isDisconnected) {
        Functions.showSnackBarApp(context, 'warning', value.warning ?? '');
      } else if (value.error != null) {
        Functions.showSnackBarApp(context, 'error', _bloc.getError());
      } else {
        _bloc.init();
      }
    });
  }

  Future<void> _moveCamera(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: _zoom,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Main:
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _key,
        backgroundColor: colors.background,
        body: StreamBuilder<bool>(
          stream: _bloc.isLoading,
          builder: (BuildContext ctx, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return Loading(
              inAsyncCall: snapshot.data ?? true,
              child: _body(),
            );
          },
        ),
      ),
    );
  }

  Widget _body() {
    return StreamBuilder(
      stream: _bloc.lstRoutes,
      builder: (BuildContext cont, AsyncSnapshot<List<RoutePlan>> snapp) {
        if (snapp.hasError) {
          return Center(child: Text(snapp.error.toString()));
        }
        List<RoutePlan> routes = snapp.data ?? [];
        return StreamBuilder(
          stream: _bloc.setPolyline,
          builder: (BuildContext ctx, AsyncSnapshot<Set<Polyline>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            Set<Polyline> polylines = snapshot.data ?? {};
            return StreamBuilder(
              stream: _bloc.currentPosition,
              builder: (BuildContext ct, AsyncSnapshot<Position> snp) {
                if (snp.hasError) {
                  return Center(child: Text(snp.error.toString()));
                }
                if (!snp.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                Position position = snp.data ?? _bloc.defaultPosition();
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - _height,
                        child: _map(polylines, position),
                      ),
                      _bottom(routes),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _map(Set<Polyline> lstRoutes, Position position) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _getPosition(position.oLat, position.oLng),
      markers: {_getMarker(position.oLat, position.oLng)},
      polylines: lstRoutes,
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      onMapCreated: (GoogleMapController controller) {
        _bloc.changeIsLoading(false);
        _controller.complete(controller);
      },
    );
  }

  Widget _bottom(List<RoutePlan> lstRoutes) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: _height,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.only(
          left: dimens.paddingCardX,
          right: dimens.paddingCardX,
          top: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tu ubicación es:',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: colors.disabled,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            StreamInputText(
              streamVal: _bloc.address,
              onChange: (val) => _bloc.changeAddress(val),
              onEnter: (String val) {
                if (val.length >= 3) {
                  LocationService.getPlace(val).then((value) {
                    Position position = Position();
                    position.oLat = value['lat'];
                    position.oLng = value['lng'];
                    _bloc.changeCurrentPosition(position);
                    _moveCamera(position.oLat, position.oLng);
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            _lstRoutePlans(lstRoutes),
          ],
        ),
      ),
    );
  }

  Widget _lstRoutePlans(List<RoutePlan> lstRoutes) {
    return Column(
      children: lstRoutes
          .map<Widget>(
            (RoutePlan route) => Container(
              padding: const EdgeInsets.only(
                left: dimens.paddingCardX,
                right: dimens.paddingCardX,
              ),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_city),
                          Text(route.name),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text('Inicio: ${route.startPoint}'),
                          const Icon(Icons.house),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Fin: ${route.endPoint}'),
                          const Icon(Icons.house),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  CameraPosition _getPosition(double lat, double lng) {
    final CameraPosition kGooglePlex = CameraPosition(
      // bearing: 192.8334901395799,
      target: LatLng(lat, lng),
      // tilt: 59.440717697143555,
      zoom: _zoom,
    );
    return kGooglePlex;
  }

  Marker _getMarker(double lat, double lng) {
    final Marker kGooglePlexMarker = Marker(
      markerId: const MarkerId('_kGooglePlex'),
      infoWindow: const InfoWindow(title: 'Mi Ubicación'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(lat, lng),
    );
    return kGooglePlexMarker;
  }
}
