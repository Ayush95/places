import 'package:flutter/material.dart';
import 'package:native_app/screens/maps_screen.dart';
import 'package:provider/provider.dart';
import 'package:native_app/providers/great_places.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = 'place-detail';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findPlaceById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 12),
          Text(
            selectedPlace.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 12),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapsScreen(
                    initialLocation: selectedPlace.location,
                    isSelecting: false,
                  ),
                ),
              );
            },
            child: Text(
              'View on Map',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
