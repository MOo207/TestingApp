import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class GeoListenPage extends StatefulWidget {
  @override
  _GeoListenPageState createState() => _GeoListenPageState();
}

class _GeoListenPageState extends State<GeoListenPage> {
  String url = 'http://192.168.43.59:8080/bus/track/5f1cc0fee4b1bb00ec5e06af';

  Geolocator geolocator = Geolocator();

  Position userLocation;

Future trackBus(String lat, String long) async {
    try {
      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'lat': lat, 'long': long}),
      );
      if (response.statusCode == 200) {
        print(lat+" "+ long);
        return "done";
      } else {
        print("not done");
        return "not completed";
      }
    } catch (e) {
      return showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Error"),
              content: new Text(e.toString()),
            ));
    }
  }

  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _getLocation().then((position) {
      setState((){
        userLocation = position;
      });
    });
    userLocation != null? trackBus(userLocation.latitude.toString(), userLocation.longitude.toString()): print("user location null");
     }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            userLocation == null
                ? CircularProgressIndicator()
                : Text("Lat: " +
                    userLocation.latitude.toString() +
                    " Long: " +
                    userLocation.longitude.toString()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: (){
                  setState((){});
                },
                              child: Text(
                  "Get Location",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      geolocator.forceAndroidLocationManager = true;
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}