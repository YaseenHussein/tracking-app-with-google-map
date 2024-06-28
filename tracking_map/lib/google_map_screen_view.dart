import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_map/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:tracking_map/utils/constant/constant_of_route.dart';

import 'package:tracking_map/utils/maps_services.dart';
import 'package:tracking_map/utils/location_service.dart';
import 'package:tracking_map/widget/custom_list_view.dart';
import 'package:tracking_map/widget/text_field_widget.dart';
import 'package:uuid/uuid.dart';

class GoogleMapScreenView extends StatefulWidget {
  const GoogleMapScreenView({super.key});

  @override
  State<GoogleMapScreenView> createState() => _GoogleMapScreenViewState();
}

class _GoogleMapScreenViewState extends State<GoogleMapScreenView> {
  late CameraPosition cameraPosition;
  Timer? debounce;
  late MapsServices mapsServices;
  late GoogleMapController googleMapController;
  late TextEditingController textFieldController;
  late Uuid uuid;
  late LatLng currentLocation;
  late LatLng destination;
  String? sessionToken;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<PlaceAutocompleteModel> places = [];
  @override
  void initState() {
    uuid = const Uuid();
    mapsServices = MapsServices();
    textFieldController = TextEditingController();
    cameraPosition = const CameraPosition(
      target: LatLng(0, 0),
    );

    getPlacesData();
    super.initState();
  }

  void getPlacesData() {
    textFieldController.addListener(
      () {
        if (debounce?.isActive ?? false) {
          debounce!.cancel();
        }

        ///this code fix popular issue when we used the real time request
        ///the problem is when  the user typing his query and the user clean his text field Quickly
        ///the request send to server but the user clear his Text field
        ///the solution is make timer with some time to be sure the user still typing or clear text
        ///this problem name is [debounce]
        debounce = Timer(const Duration(milliseconds: 500), () async {
          sessionToken ??= uuid.v4();
          await mapsServices.getPredictions(
            input: textFieldController.text,
            sessionToken: sessionToken!,
            places: places,
          );
          setState(() {});
        });
      },
    );
  }

  @override
  void dispose() {
    textFieldController.dispose();
    googleMapController.dispose();
    debounce!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateCurrentLocation();
          setState(() {});
        },
        child: const Icon(Icons.location_pin),
      ),
      resizeToAvoidBottomInset:
          false, //this make the  a scaffold's body not move up when the keyword open if the bool value is false
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              polylines: polylines,
              markers: markers,
              onMapCreated: (controller) {
                googleMapController = controller;
                updateCurrentLocation();
              },
              initialCameraPosition: cameraPosition,
              zoomControlsEnabled: false,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: textFieldController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (ConstantOfRoute.duration.isNotEmpty &&
                      ConstantOfRoute.distanceMeters.isNotEmpty) ...[
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(15))),
                          child: Text(ConstantOfRoute.duration),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(15))),
                          child: Text(
                              "${int.parse(ConstantOfRoute.distanceMeters) / 1000}K"),
                        ),
                      ],
                    ),
                  ],
                  CustomListView(
                    onPlaceSelect: (placeDetails) async {
                      textFieldController.clear();
                      places.clear();
                      sessionToken = null;

                      destination = LatLng(
                          placeDetails.geometry!.location!.lat!,
                          placeDetails.geometry!.location!.lng!);
                      Marker destinationMarker = Marker(
                        markerId: const MarkerId("destination_marker"),
                        position: destination,
                      );
                      markers.add(
                        destinationMarker,
                      );
                      List<LatLng> points = await mapsServices.getRouteData(
                        currentLocation: currentLocation,
                        des: destination,
                      );

                      mapsServices.displayRoute(
                          points: points,
                          googleMapController: googleMapController,
                          polylines: polylines);
                      setState(() {});
                    },
                    places: places,
                    mapService: mapsServices,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateCurrentLocation() async {
    try {
      currentLocation = await mapsServices.updateCurrentLocation(
          markers: markers, googleMapController: googleMapController);
      setState(() {});
    } on LocationServiceException catch (e) {
      print(e.message);
    } on LocationPermissionException catch (e) {
      print(e.message);
    } catch (e) {
      print(e.toString());
    }
  }
}

//create text field
//listen to text field
//make request each time input change(google maps place)
//display list of result(places)
