import 'package:flutter/material.dart';
import 'package:map/constant/my_colors.dart';
import 'package:map/data/models/places.dart';

class PlaceItem extends StatelessWidget {
  final Places places;

  PlaceItem({required this.places});

  @override
  Widget build(BuildContext context) {
    var subtitle =
        places.description.replaceAll(places.description.split(',')[0], '');
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: MyColors.lightBlue),
              child: Icon(
                Icons.place,
                color: MyColors.blue,
              ),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${places.description.split(','[0])}\n',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: subtitle.substring(2),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
