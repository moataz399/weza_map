part of 'places_cubit.dart';

@immutable
abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoaded extends PlacesState {
  final List<dynamic> places;

  PlacesLoaded(this.places);
}

class PlaceLocationLoaded extends PlacesState {
  final PlaceDetails place;

  PlaceLocationLoaded(this.place);
}




class PlaceDirectionsLoaded extends PlacesState {
  final  PlaceDirections directions;

  PlaceDirectionsLoaded( this.directions);
}