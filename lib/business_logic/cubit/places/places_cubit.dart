import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/data/models/place_details.dart';
import 'package:map/data/models/place_directions.dart';
import 'package:map/data/models/place_directions.dart';
import 'package:map/data/models/places.dart';
import 'package:map/data/repository/maps_repo.dart';
import 'package:meta/meta.dart';

part 'places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  final MapsRepository mapsRepository;

  PlacesCubit(this.mapsRepository) : super(PlacesInitial());

  void emitPlaces(String place, String sessionToken) async {
    mapsRepository.fetchPlaces(place, sessionToken).then(
      (places) {
        emit(PlacesLoaded(places));
      },
    );
  }

  void emitPlaceLocation(String placeId, String sessionToken) async {
    mapsRepository.getPlacesLocation(placeId, sessionToken).then(
      (place) {
        emit(PlaceLocationLoaded(place));
      },
    );
  }

  void emitPlaceDirections(LatLng origin, LatLng destination) async {
    mapsRepository.getDirections(origin, destination).then(
      (directions) {
        emit(PlaceDirectionsLoaded(directions));
      },
    );
  }
}
