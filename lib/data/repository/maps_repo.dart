import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/data/models/place_details.dart';
import 'package:map/data/models/place_directions.dart';
import 'package:map/data/web_services/places_web_services.dart';
import 'package:map/data/models/places.dart';

class MapsRepository {
  final PlacesWebServices placesWebServices;

  MapsRepository(this.placesWebServices);

  Future<List<dynamic>> fetchPlaces(String place, String sessionToken) async {
    final places = await placesWebServices.fetchPlaces(place, sessionToken);
    return places.map((place) => Places.fromJson(place)).toList();
  }

  Future<dynamic> getPlacesLocation(String placeId, String sessionToken) async {
    final placeDetails =
        await placesWebServices.getPlaceLocation(placeId, sessionToken);

    return PlaceDetails.fromJson(placeDetails);
  }

  Future<dynamic> getDirections(LatLng origin, LatLng destination) async {
    final directions =
        await placesWebServices.getDirection(origin, destination);



    return PlaceDirections.fromJson(directions);
  }
}
