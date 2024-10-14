import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class LocationModel {
  final String address;
  final String city;
  final String region;
  final String postalCode;
  final String countryISOCode;
  final String? mainText, secondaryText;
  final String formattedText;
  final String? country;
  final GeoPoint? geopoint;
  final GeoFirePoint? location;

  const LocationModel(
    this.address,
    this.city,
    this.region,
    this.postalCode, {
    this.countryISOCode = 'FR',
    this.mainText,
    this.secondaryText,
    required this.formattedText,
    this.geopoint,
    this.location,
    this.country,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) => LocationModel(
        map['address'],
        map['city'],
        map['region'],
        map['postal_code'],
        countryISOCode: map['country_iso_code'],
        formattedText: map['formatted_text'],
        geopoint: map['geopoint'],
        country: map['country'],
      );

  Map<String, dynamic> toMap() => {
        'address': address,
        'city': city,
        'geopoint': geopoint,
        'location': location?.data,
        'region': region,
        'postal_code': postalCode,
        'country_iso_code': countryISOCode,
        'formatted_text': formattedText,
        'country': country,
      };

  factory LocationModel.fromGooglePlace(Map<String, dynamic> predictionMap, Map<String, dynamic> placeMap) {
    String? streetNumber, route, locality, region, postalCode, countryISOCode, country;

    for (final component in placeMap['result']['address_components']) {
      final types = List.castFrom<dynamic, String>(component['types']);
      if (types.contains('street_number')) {
        streetNumber = component['long_name'];
      } else if (types.contains('route')) {
        route = component['long_name'];
      } else if (types.contains('locality')) {
        locality = component['long_name'];
      } else if (types.contains('administrative_area_level_1')) {
        region = component['long_name'];
      } else if (types.contains('postal_code')) {
        postalCode = component['long_name'];
      } else if (types.contains('country')) {
        countryISOCode = component['short_name'];
        country = component['long_name'];
      }
    }

    return LocationModel(
      '$streetNumber $route',
      locality ?? "",
      region ?? "",
      postalCode ?? "",
      countryISOCode: countryISOCode ?? "",
      mainText: predictionMap['structured_formatting']['main_text'],
      secondaryText: predictionMap['structured_formatting']['secondary_text'],
      formattedText: placeMap['result']['formatted_address'],
      geopoint: GeoPoint(placeMap['result']['geometry']['location']['lat'], placeMap['result']['geometry']['location']['lng']),
      location: Geoflutterfire().point(latitude: placeMap['result']['geometry']['location']['lat'], longitude: placeMap['result']['geometry']['location']['lng']),
      country: country,
    );
  }

  @override
  String toString() => '''
| adress: $address,
| city: $city
| regions: $region
| postal_code: $postalCode
| country_iso_code: $countryISOCode
| main_text: $mainText
| secondary_text: $secondaryText
| formatted_text: $formattedText
''';
}
