import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePage();
  }
}

class _MyHomePage extends State<MyHomePage> {
  String locationString = 'Doha ,Qatar';
  double log = 51.5310, lat = 25.2854;

  static final kGoogleApiKey = "AIzaSyB_cLg0X1c392MMvI-gTAmltJvnCb7RVWg";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(40.0),
      child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('Show Autocomplete Google place'),
            onPressed: () {
              setUpSearch(context);
            },
          ),
          Text(locationString +
              ",lat:" +
              lat.toString() +
              ",log:" +
              log.toString())
        ],
      ),
    ));
  }

  void setUpSearch(context) async {
    Prediction p =
        await PlacesAutocomplete.show(context: context, apiKey: kGoogleApiKey);
    displayPrediction(p);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      //var placeId = p.placeId;
      double lati = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      setState(() {
        locationString = address.first.addressLine;
        log = lng;
        lat = lati;
      });
    }
  }
}
