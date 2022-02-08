import 'package:flutter/material.dart';

import 'package:map/constant/my_colors.dart';
import 'package:map/data/models/place_directions.dart';

class DistanceAndTime extends StatelessWidget {
  final PlaceDirections? placeDirections;
  final bool isDistanceAndTimeVisible;

  const DistanceAndTime(
      {Key? key, this.placeDirections, required this.isDistanceAndTimeVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isDistanceAndTimeVisible,
      child: Positioned(
        top: 0,
        bottom: 550,
        left: 0,
        right: 0,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
                color: Colors.white,
                child: ListTile(
                  dense: true,
                  horizontalTitleGap: 0.0,
                  leading: Icon(
                    Icons.access_time_filled,
                    color: MyColors.blue,
                    size: 30,
                  ),
                  title: Text(
                    placeDirections!.totalDuration,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 0,
            ),
            Flexible(
              flex: 1,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
                color: Colors.white,
                child: ListTile(
                  dense: true,
                  horizontalTitleGap: 0.0,
                  leading: Icon(
                    Icons.directions_car_filled,
                    color: MyColors.blue,
                    size: 30,
                  ),
                  title: Text(
                    placeDirections!.totalDistance,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
