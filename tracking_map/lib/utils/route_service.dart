import 'dart:convert';

import 'package:tracking_map/models/loction_info/location_info_model.dart';
import 'package:tracking_map/models/route_model/routes_model.dart';
import 'package:http/http.dart' as http;
import 'package:tracking_map/models/route_modifiers_info.dart';

class RouteService {
  final String baseUrl =
      "https://routes.googleapis.com/directions/v2:computeRoutes";
  final String apiKey = "AIzaSyC63hxrJucY0A_kVtcugY2p-W4Wk0MDVGM";

  ///this is constants that means the Content-Type and  X-Goog-FieldMask is const in [header]

  Future<RoutesModel> fetchRoutes({
    required LocationInfoModel origin,
    required LocationInfoModel destination,
    RouteModifiersInfo? routeModifiers,
  }) async {
    Uri url = Uri.parse(baseUrl);
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
    };

    Map<String, dynamic> body = {
      "origin": origin.toJson(),
      "destination": destination.toJson(),
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "computeAlternativeRoutes": false,
      "routeModifiers": routeModifiers == null
          ? RouteModifiersInfo().toJson()
          : routeModifiers.toJson(),
      "languageCode": "en-US",
      "units": "IMPERIAL"
    };
    var response =
        await http.post(url, headers: header, body: jsonEncode(body));
    if (response.statusCode == 200) {
      return RoutesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("not routes founds");
    }
  }
}
