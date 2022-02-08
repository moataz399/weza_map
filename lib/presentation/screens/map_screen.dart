import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/business_logic/cubit/places/places_cubit.dart';
import 'package:map/data/models/place_details.dart';
import 'package:map/data/models/place_directions.dart';
import 'package:map/data/models/places.dart';
import 'package:map/helpers/Location_helper.dart';
import 'package:map/presentation/place_item.dart';
import 'package:map/presentation/screens/distance_and_time.dart';
import 'package:map/presentation/widgets/my_drawer.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void dispose() {
    super.dispose();
    mapController?.dispose();
    searchBarController.dispose();
  }

  @override
  initState() {
    super.initState();
    getCurrentLocation();
  }

  late List<dynamic> places;

  static Position? position;
  GoogleMapController? mapController;
  FloatingSearchBarController searchBarController =
      FloatingSearchBarController();

  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    target: LatLng(position!.latitude, position!.longitude),
    zoom: 17,
    bearing: 0.0,
    tilt: 0.0,
  );

  // these variables for get place location
  Set<Marker> markers = Set();
  late Places placesSuggestion;
  late PlaceDetails selectedPlace;
  late Marker searchedPlaceMarker;
  late Marker currentLocationMarker;
  late CameraPosition goToSearchedPlace;

  // these variables for get place directions
  PlaceDirections? placeDirections;
  var progressIndicator = false;
  late List<LatLng> polyLinePoints;
  var isSearchedPlaceMarkerClicked = false;
  var isDistanceAndTimeVisible = false;
  late String distance;
  late String time;

  void buildCameraNewPosition() {
    goToSearchedPlace = CameraPosition(
        zoom: 13,
        bearing: 0.0,
        tilt: 0.0,
        target: LatLng(selectedPlace.result.geometry.location.lat,
            selectedPlace.result.geometry.location.lng));
  }

  Widget _buildMap() => GoogleMap(
        markers: markers,
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        onMapCreated: (controller) => mapController = controller,
        myLocationEnabled: true,
        initialCameraPosition: _myCurrentLocationCameraPosition,
        polylines: placeDirections != null
            ? {
                Polyline(
                  polylineId: const PolylineId('poly'),
                  color: Colors.black,
                  width: 2,
                  points: polyLinePoints,
                )
              }
            : {},
      );

  Future<void> getCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController? controller = mapController;
    controller?.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      controller: searchBarController,
      progress: progressIndicator,
      elevation: 6,
      hintStyle: TextStyle(fontSize: 18),
      queryStyle: TextStyle(fontSize: 18),
      hint: 'Find a place..',
      border: BorderSide(style: BorderStyle.none),
      margins: EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: 50,
      iconColor: Colors.blue,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        getPlaces(query);
      },
      onFocusChanged: (_) {
        // hide distance and time row
        setState(() {
          isDistanceAndTimeVisible = false;
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(
              Icons.place,
              color: Colors.black.withOpacity(0.6),
            ),
            onPressed: () {},
          ),
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildPlacesBloc(),
              buildSelectedPlaceLocationBloc(),
              buildDirectionsBloc()
            ],
          ),
        );
      },
    );
  }

  Widget buildDirectionsBloc() {
    return BlocListener<PlacesCubit, PlacesState>(
      listener: (context, state) {
        if (state is PlaceDirectionsLoaded) {
          placeDirections = (state).directions;
          getPolyLinePoints();
        }
      },
      child: Container(),
    );
  }

  void getPolyLinePoints() {
    polyLinePoints = placeDirections!.polylinePoints
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
  }

  Widget buildSelectedPlaceLocationBloc() {
    return BlocListener<PlacesCubit, PlacesState>(
      listener: (context, state) {
        if (state is PlaceLocationLoaded) {
          selectedPlace = state.place;
          goToMySearchedForLocation();
          getDirections();
        }
      },
      child: Container(),
    );
  }

  void getDirections() {
    BlocProvider.of<PlacesCubit>(context).emitPlaceDirections(
        LatLng(position!.latitude, position!.longitude),
        LatLng(selectedPlace.result.geometry.location.lat,
            selectedPlace.result.geometry.location.lng));
  }

  Future<void> goToMySearchedForLocation() async {
    buildCameraNewPosition();
    final GoogleMapController? controller = mapController;
    controller
        ?.animateCamera(CameraUpdate.newCameraPosition(goToSearchedPlace));
    buildSearchedPlaceMarker();
  }

  buildSearchedPlaceMarker() {
    searchedPlaceMarker = Marker(
      position: goToSearchedPlace.target,
      markerId: MarkerId('1'),
      onTap: () {
        buildCurrentLocationMarker();
        //show time and distance
        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isDistanceAndTimeVisible = true;
        });
      },
      infoWindow: InfoWindow(
        title: '${placesSuggestion.description}',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkerToMarkersAndUpdateUi(searchedPlaceMarker);
  }

  void buildCurrentLocationMarker() {
    currentLocationMarker = Marker(
      position: LatLng(position!.latitude, position!.longitude),
      markerId: MarkerId('2'),
      onTap: () {},
      infoWindow: InfoWindow(
        title: 'Your Current Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    addMarkerToMarkersAndUpdateUi(currentLocationMarker);
  }

  void addMarkerToMarkersAndUpdateUi(Marker marker) {
    setState(() {
      markers.add(marker);
    });
  }

  Widget buildPlacesBloc() {
    return BlocBuilder<PlacesCubit, PlacesState>(builder: (context, state) {
      if (state is PlacesLoaded) {
        places = state.places;
        if (places.length != 0) {
          return buildPlacesList();
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    });
  }

  Widget buildPlacesList() {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            placesSuggestion = places[index];

            searchBarController.clear();
            getSelectedPlaceLocation();

            // removeAllMarkersAndUpdateUi();
          },
          child: PlaceItem(places: places[index]),
        );
      },
      itemCount: places.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
  }

  void getSelectedPlaceLocation() {
    final sessionToken = Uuid().v4();
    BlocProvider.of<PlacesCubit>(context)
        .emitPlaceLocation(placesSuggestion.placeId, sessionToken);
  }

  getPlaces(String query) {
    final sessionToken = Uuid().v4();
    BlocProvider.of<PlacesCubit>(context).emitPlaces(query, sessionToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null
              ? _buildMap()
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
          buildFloatingSearchBar(),
          isSearchedPlaceMarkerClicked
              ? DistanceAndTime(
                  isDistanceAndTimeVisible: isDistanceAndTimeVisible,
                  placeDirections: placeDirections,
                )
              : Container(),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 8, 30),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: _goToMyCurrentLocation,
          child: Icon(
            Icons.place,
            color: Colors.white,
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
