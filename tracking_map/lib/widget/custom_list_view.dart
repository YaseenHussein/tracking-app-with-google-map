import 'package:flutter/material.dart';
import 'package:tracking_map/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:tracking_map/models/place_details_model/place_details_model.dart';
import 'package:tracking_map/utils/maps_services.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
    required this.places,
    required this.mapService,
    required this.onPlaceSelect,
  });

  final List<PlaceAutocompleteModel> places;
  final MapsServices mapService;
  final Function(PlaceDetailsModel) onPlaceSelect;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: places.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 0,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () async {
              var placeData = await mapService.getPlaceDetails(
                  placeId: places[index].placeId!);
              onPlaceSelect(placeData);
            },
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            leading: const Icon(
              Icons.location_on_rounded,
              color: Colors.red,
            ),
            title: Text(places[index].description!),
          );
        },
      ),
    );
  }
}
