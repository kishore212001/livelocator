// ignore_for_file: file_names
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

//-ImagePickerProvider--------------------------------------------------------//
class LocationProvider with ChangeNotifier {
  final Completer<GoogleMapController> googleMapController = Completer();
  CameraPosition? cameraPosition;
  Location? _location;
  LocationData? currentLocation;
  final apiKey = 'your API key';

  // ignore: non_constant_identifier_names
  String? Findcity = '';

  // ignore: non_constant_identifier_names
  String? Findstate = '';

  // ignore: non_constant_identifier_names
  String? Findcountry = '';

  // ignore: non_constant_identifier_names
  String? FindformattedAddress = '';

//----------------------------------------------------------------------------//
  init() async {
    _location = Location();
    cameraPosition = const CameraPosition(
        target: LatLng(
            0, 0), // this is just the example lat and lng for initializing
        zoom: 15);
    _initLocation();
  }

//----------------------------------------------------------------------------//
  //function to listen when we move position
  _initLocation() {
    //use this to go to current location instead
    _location?.getLocation().then((location) {
      currentLocation = location;
      notifyListeners();
    });
    _location?.onLocationChanged.listen((newLocation) {
      currentLocation = newLocation;
      moveToPosition(LatLng(
          currentLocation?.latitude ?? 0, currentLocation?.longitude ?? 0));
      notifyListeners();
    });
  }

//----------------------------------------------------------------------------//
  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15)));
    var addressInfo = await getAddressFromCoordinates(
        currentLocation?.latitude ?? 0,
        currentLocation?.longitude ?? 0,
        apiKey);
    /* if (kDebugMode) {
      print("================");
      print('City: ${addressInfo['city']}');
      print('State: ${addressInfo['state']}');
      print('Country: ${addressInfo['country']}');
      print('Formatted Address: ${addressInfo['formattedAddress']}');
    } */
    notifyListeners();
  }

//----------------------------------------------------------------------------//
  Future<Map<String, String>> getAddressFromCoordinates(
      double latitude, double longitude, String apiKey) async {
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'] is List) {
        final results = data['results'] as List;
        // print(results);
        if (results.isNotEmpty) {
          final addressComponents = results[0]['address_components'] as List;
          String city = '';
          String state = '';
          String country = '';
          String formattedAddress = results[0]['formatted_address'];

          for (final component in addressComponents) {
            final types = component['types'] as List;
            if (types.contains('locality')) {
              city = component['long_name'];
            } else if (types.contains('administrative_area_level_1')) {
              state = component['long_name'];
            } else if (types.contains('country')) {
              country = component['long_name'];
            }
          }
          notifyListeners();
          final result = {
            'city': city,
            'state': state,
            'country': country,
            'formattedAddress': formattedAddress,
          };
          Findcity = result['city'];
          Findstate = result['state'];
          Findcountry = result['country'];
          FindformattedAddress = result['formattedAddress'];
          /*if (kDebugMode) {
            print("================result");
          }*/
          notifyListeners();
          return result;
        }
      }
    }

    // Return an empty map or handle errors as needed.
    return {};
  }
}
