import 'dart:convert';

import 'package:tracking_map/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:http/http.dart' as http;
import 'package:tracking_map/models/place_details_model/place_details_model.dart';

class PlaceService {
  String baseUrl = "https://maps.googleapis.com/maps/api/place";
  String apiKey = "AIzaSyC63hxrJucY0A_kVtcugY2p-W4Wk0MDVGM";
  Future<List<PlaceAutocompleteModel>> getPredictions({
    required String input,
    String language = 'en',
    String country = 'ye',
    required String sessionToken,
  }) async {
    var response = await http.get(Uri.parse(
        '$baseUrl/autocomplete/json?input=$input&key=$apiKey&language=$language&components=country:$country&sessiontoken=$sessionToken'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['predictions'];
      List<PlaceAutocompleteModel> places = [];
      for (var items in data) {
        places.add(PlaceAutocompleteModel.fromJson(items));
      }
      return places;
    } else {
      throw Exception();
    }
  }

  Future<PlaceDetailsModel> getPlaceDetails({
    required String placeId,
    String language = 'en',
  }) async {
    var response = await http.get(Uri.parse(
        '$baseUrl/details/json?place_id=$placeId&key=$apiKey&language=$language'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['result'];

      return PlaceDetailsModel.fromJson(data);
    } else {
      throw Exception();
    }
  }
}
