import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/constant/Strings.dart';

class PlacesWebServices {
  late Dio dio; //declaration

  PlacesWebServices() {
    BaseOptions options = BaseOptions(
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);

    //instantiation
  }

// change the key
  Future<List<dynamic>> fetchPlaces(String place, String sessionToken) async {
    try {
      Response response = await dio.get(placeSuggestionUrl, queryParameters: {
        'input': place,
        'types': 'address',
        'components': 'country:eg',
        'key': 'valid api key',
        'sessiontoken': sessionToken,
      });
      print(response.data['predictions']);
      print(response.statusCode);
      return response.data['predictions'];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<dynamic> getPlaceLocation(String placeId, String sessionToken) async {
    try {
      Response response = await dio.get(placeLocationUrl, queryParameters: {
        'place_id': placeId,
        'fields': 'geometry',
        'key': 'valid api key',
        'sessiontoken': sessionToken,
      });

      return response.data;
    } catch (error) {
      print(error.toString());
      return Future.error('Place Location error : ',
          StackTrace.fromString('this is its trace'));
    }
  }

  // origin = current Location;
  // destination= searched for location;

  Future<dynamic> getDirection(LatLng origin, LatLng destination) async {
    try {
      Response response = await dio.get(directionUrl, queryParameters: {
        'key': 'AIzaSyAdvXvIQSrguEjx4zPLkjxCYJDYK-tBIrE',
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
      });

      return response.data;
    } catch (error) {
      print(error.toString());
      return Future.error('Place Location error : ',
          StackTrace.fromString('this is its trace'));
    }
  }
}
