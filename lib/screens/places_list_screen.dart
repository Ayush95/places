import 'package:flutter/material.dart';
import 'package:native_app/providers/great_places.dart';
import 'package:native_app/screens/add_place_screen.dart';
import 'package:native_app/screens/places_details_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<GreatPlaces>(
                child: Center(
                  child: Text(
                    "No Place added yet !! Add some of them :)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                builder: (ctx, greatPlace, ch) => greatPlace.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: greatPlace.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatPlace.items[i].image),
                          ),
                          title: Text(
                            greatPlace.items[i].title,
                          ),
                          subtitle: Text(
                            greatPlace.items[i].location.address,
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PlaceDetailsScreen.routeName,
                              arguments: greatPlace.items[i].id,
                            );
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
