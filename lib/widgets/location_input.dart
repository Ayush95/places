import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';
import 'package:native_app/screens/maps_screen.dart';
import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImage;

  void showPreview(double lat, double lng) {
     final _staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );
    setState(() {
      _previewImage = _staticMapImageUrl;
    });
  }

  Future<void> _getCurrentLocation() async {
    try{
    final locData = await Location().getLocation();
   showPreview(locData.latitude, locData.longitude);
    widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch(error){
      return;
    }
  }

  Future<void> _selectonMap() async {
   final selectedLocation =  await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapsScreen(
          isSelecting: true,
        ),
      ),
    );
    if(selectedLocation == null) {
      return;
    }
    showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImage == null
              ? Center(
                  child: Text(
                    'No Location Chosen',
                    textAlign: TextAlign.center,
                  ),
                )
              : Image.network(
                  _previewImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectonMap,
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ],
    );
  }
}
