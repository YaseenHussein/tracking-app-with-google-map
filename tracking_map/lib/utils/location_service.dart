import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  Future<void> checkAndRequestLocationService() async {
    bool isServicesEnabled = await location.serviceEnabled();
    if (!isServicesEnabled) {
      bool isClientEnableService = await location.requestService();
      if (!isClientEnableService) {
        throw LocationServiceException(
            message: "the user don't enable the service");
      }
    }
  }

  Future<void> checkAndRequestLocationPermission() async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.deniedForever) {
      throw LocationPermissionException(
          message: "user  denied  forever the permission");
    }
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        throw LocationPermissionException(
            message: "user didn't granted permission");
      }
    }
  }

  void getRealTimeLocation(void Function(LocationData)? onData) async {
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    location.onLocationChanged.listen(onData);
  }

  Future<LocationData> getLocation() async {
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    return await location.getLocation();
  }
}

class LocationServiceException implements Exception {
  final String message;

  LocationServiceException({required this.message});
}

class LocationPermissionException implements Exception {
  final String message;

  LocationPermissionException({required this.message});
}
