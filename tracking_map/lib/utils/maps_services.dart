import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_map/models/loction_info/lat_lng_model.dart';
import 'package:tracking_map/models/loction_info/location_info_model.dart';
import 'package:tracking_map/models/loction_info/location_model.dart';
import 'package:tracking_map/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:tracking_map/models/place_details_model/place_details_model.dart';
import 'package:tracking_map/models/route_model/routes_model.dart';
import 'package:tracking_map/utils/constant/constant_of_route.dart';
import 'package:tracking_map/utils/location_service.dart';
import 'package:tracking_map/utils/place_service.dart';
import 'package:tracking_map/utils/route_service.dart';

class MapsServices {
  LocationService locationService = LocationService();
  PlaceService placeService = PlaceService();
  RouteService routeService = RouteService();
  Future<void> getPredictions({
    required String input,
    required String sessionToken,
    required List<PlaceAutocompleteModel> places,
  }) async {
    if (input.trim().isNotEmpty) {
      var result = await placeService.getPredictions(
          sessionToken: sessionToken, input: input);
      places.clear();
      places.addAll(result);
    } else {
      places.clear();
    }
  }

  Future<List<LatLng>> getRouteData(
      {required LatLng currentLocation, required LatLng des, s}) async {
    LocationInfoModel origin = LocationInfoModel(
        location: LocationModel(
            latLng: LatLngModel(
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
    )));
    LocationInfoModel destination = LocationInfoModel(
        location: LocationModel(
            latLng: LatLngModel(
      latitude: des.latitude,
      longitude: des.longitude,
    )));
    RoutesModel routesData = await routeService.fetchRoutes(
        origin: origin, destination: destination);
    ConstantOfRoute.duration = routesData.routes!.first.duration!;
    ConstantOfRoute.distanceMeters =
        routesData.routes!.first.distanceMeters!.toString();

    List<LatLng> listLatLng = getDecodedPolylineOfRoute(routesData);
    return listLatLng;
  }

  List<LatLng> getDecodedPolylineOfRoute(RoutesModel routesData) {
    PolylinePoints polylinePoints =
        PolylinePoints(); //this package we install it from net to help us to decode PolyLine its name is flutter_polyline_points
    List<PointLatLng> result = polylinePoints
        .decodePolyline(routesData.routes!.first.polyline!.encodedPolyline!);

    List<LatLng> listLatLng =
        result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return listLatLng;
  }

  void displayRoute(
      {required List<LatLng> points,
      required Set<Polyline> polylines,
      required GoogleMapController googleMapController}) {
    Polyline route = Polyline(
        width: 5,
        polylineId: const PolylineId("route"),
        color: Colors.blue,
        points: points);
    polylines.clear();
    polylines.add(route);
    LatLngBounds latLngBounds = getLatLngBounds(points: points);
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 20));
  }

  ///this function use to animate camera to see full the route who create it
  ///first we should get the min latitude and longitude in our [points]
  ///secund we get the max latitude and max longitude  in our [points]

  LatLngBounds getLatLngBounds({
    required List<LatLng> points,
  }) {
    var southwestLat = points.first.latitude;
    var southwestLng = points.first.longitude;

    var northeastLat = points.first.latitude;
    var northeastLng = points.first.longitude;
    for (var point in points) {
      southwestLat = min(southwestLat, point.latitude);
      southwestLng = min(southwestLng, point.longitude);
      northeastLat = max(northeastLat, point.latitude);
      northeastLng = max(northeastLng, point.longitude);
    }
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLng),
        northeast: LatLng(northeastLat, northeastLng));
  }

  Future<LatLng> updateCurrentLocation(
      {required Set<Marker> markers,
      required GoogleMapController googleMapController}) async {
    var locationData = await locationService.getLocation();
    var currentLocation = LatLng(
      locationData.latitude!,
      locationData.longitude!,
    );
    Marker marker = Marker(
        markerId: const MarkerId("My_current_location"),
        position: currentLocation);

    CameraPosition locationCameraPosition =
        CameraPosition(target: currentLocation, zoom: 16);
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(locationCameraPosition));
    markers.add(marker);
    return currentLocation;
  }

  Future<PlaceDetailsModel> getPlaceDetails({
    required String placeId,
  }) {
    return placeService.getPlaceDetails(placeId: placeId);
  }
}
