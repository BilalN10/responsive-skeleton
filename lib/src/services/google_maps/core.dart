import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_kosmos/skeleton_kosmos.dart';
// import 'package:weal/models/direction_details/directionDetails.dart';

Future<List<LocationModel>> placeAutocomplete(String query, String language, {String? country = "fr"}) async {
  final mapKey = GetIt.instance<ApplicationDataModel>().gmapKey;

  final autocompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$mapKey&language=$language${country == null ? "" : "&components=country:$country"}';

  final autocompleteRes = await http.get(Uri.parse(autocompleteUrl));
  if (autocompleteRes.statusCode != 200) {
    return [];
  }
  final res = <LocationModel>[];

  for (final prediction in json.decode(autocompleteRes.body)['predictions']) {
    final placeId = prediction['place_id'];
    final placeUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?key=$mapKey&place_id=$placeId&fields=geometry,formatted_address,address_components';
    final placeRes = await http.get(
      Uri.parse(placeUrl),
      headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*",
      },
    );

    if (placeRes.statusCode != 200) {
      continue;
    }

    final place = json.decode(placeRes.body);
    res.add(LocationModel.fromGooglePlace(prediction, place));
  }
  return res;
}

Future<LocationModel?> reverseGeocode(double latitude, double longitude, [String language = 'fr']) async {
  final mapKey = GetIt.instance<ApplicationDataModel>().gmapKey;
  final url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$mapKey&language=$language';
  final res = await http.get(Uri.parse(url));

  if (res.statusCode != 200) {
    return null;
  }

  for (final place in json.decode(res.body)['results']) {
    return LocationModel(
      '${place["address_components"][0]["long_name"]} ${place["address_components"][1]["long_name"]}',
      '${place["address_components"][2]["long_name"]}',
      '${place["address_components"][6]["long_name"]}',
      '',
      formattedText: place['formatted_address'],
      geopoint: GeoPoint(latitude, longitude),
      location: Geoflutterfire().point(latitude: latitude, longitude: longitude),
    );
  }

  return null;
}

// Future<DirectionDetails?> obtainPlaceDirectionsDetails(LatLng initialPosition, LatLng finalPosition) async {
//   print("obtainPlaceDirectionsDetails");
//   String directionUrl =
//       "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&language=fr&key=$mapKey&mode=bicycling";
//   var res = await getRequest(directionUrl);
//   if (res == "failed") {
//     return null;
//   }
//   DirectionDetails directionDetail = DirectionDetails(
//       distanceValue: res['routes'][0]['legs'][0]['distance']['value'],
//       durationValue: res['routes'][0]['legs'][0]['duration']['value'],
//       distanceText: res['routes'][0]['legs'][0]['distance']['text'],
//       durationText: res['routes'][0]['legs'][0]['duration']['text'],
//       encodedPoints: res['routes'][0]['overview_polyline']['points']);

//   return directionDetail;
// }

Future<dynamic> getRequest(String url) async {
  try {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String jsonData = response.body;
      var decodeData = jsonDecode(jsonData);
      return decodeData;
    } else {
      return "Failed no response";
    }
  } catch (dynamic) {
    return "Failed";
  }
}

LatLngBounds boundsFromLatLngList(List<LatLng> list) {
  assert(list.isNotEmpty);
  double? x0, x1, y0, y1;
  for (LatLng latLng in list) {
    if (x0 == null) {
      x0 = x1 = latLng.latitude;
      y0 = y1 = latLng.longitude;
    } else {
      if (latLng.latitude > x1!) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1!) y1 = latLng.longitude;
      if (latLng.longitude < y0!) y0 = latLng.longitude;
    }
  }
  return LatLngBounds(northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
}
