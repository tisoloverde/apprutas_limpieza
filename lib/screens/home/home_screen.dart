import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:solo_verde/services/location.service.dart';

import 'package:solo_verde/blocs/home/home.bloc.dart';

import 'package:solo_verde/models/geo.model.dart';

import 'package:solo_verde/widgets/loading_app.dart';

import 'package:solo_verde/values/colors.dart' as colors;
import 'package:solo_verde/values/dimens.dart' as dimens;
import 'package:solo_verde/widgets/stream_input_text.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool _isInit = true;
  final double _height = 120;
  final double _zoom = 19.151926040649414;

  HomeBloc _bloc = HomeBloc();
  final _controller = Completer<GoogleMapController>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) return;
    setState(() => _isInit = false);
    _bloc = Provider.of<HomeBloc>(context);
    _bloc.init();
  }

  @override
  void initState() {
    super.initState();
    LocationService.currentLocation().then((value) {
      _bloc.changeCurrentPosition(Position.fromJson(value));
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _body(),
                    _bottom(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _body() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - _height,
      child: _map(),
    );
  }

  Widget _map() {
    return StreamBuilder(
      stream: _bloc.lstRoutes,
      builder: (BuildContext ctx, AsyncSnapshot<List<RoutePlan>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        List<RoutePlan> routes = snapshot.data ?? [];
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
            Set<Polyline> setRoutes = routes
                .asMap()
                .map((int idx, RoutePlan route) => MapEntry(
                      idx,
                      _getCoords(idx, route),
                    ))
                .values
                .toSet();
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _getPosition(position.lat, position.lng),
              markers: {_getMarker(position.lat, position.lng)},
              polylines: setRoutes,
              onMapCreated: (GoogleMapController controller) {
                _bloc.changeIsLoading(false);
                _controller.complete(controller);
              },
            );
          },
        );
      },
    );
  }

  Widget _bottom() {
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
          // top: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                LocationService.getPlace(val).then((value) {
                  Position position = Position();
                  position.lat = value['lat'];
                  position.lng = value['lng'];
                  _bloc.changeCurrentPosition(position);
                  _moveCamera(position.lat, position.lng);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  CameraPosition _getPosition(double lat, double lng) {
    final CameraPosition kGooglePlex = CameraPosition(
      // bearing: 192.8334901395799,
      target: LatLng(lat, lng),
      // tilt: 59.440717697143555,
      zoom: 19.151926040649414,
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

  Polyline _getCoords(int index, RoutePlan route) {
    List<LatLng> coords = route.coords
        .map(
          (Position pos) => LatLng(pos.lat, pos.lng),
        )
        .toList();
    final Polyline polyline = Polyline(
      polylineId: PolylineId('_kPolyline_$index'),
      points: coords,
    );
    return polyline;
  }
}
