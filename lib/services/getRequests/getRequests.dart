import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetRequests extends StatefulWidget {
  @override
  _GetRequestsState createState() => _GetRequestsState();
}


class _GetRequestsState extends State<GetRequests> {
  Future<Bus> _future;

  @override
  void initState(){
    super.initState();
  }

 Future<Bus> fetchBuses() async {
  final response = await http.get('http://192.168.43.59:8080/bus');
  if (response.statusCode == 200) {
    return Bus.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

  List<String> notes = [
    "Here",
    "We",
    "Will",
    "add",
    "Get",
    "Requests"
  ];

  void doFetch(){
    setState(() {
          _future = fetchBuses();
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, pos) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Text(notes[pos])
            ),
          )
        );

      },
    );
  }
}

class Bus {
    String status;
    int maxCap;
    int currentCap;
    String lat;
    String long;
    String source;
    String destination;

  Bus({this.status, this.currentCap, this.maxCap, this.source, this.destination, this.long, this.lat});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      status: json['status'],
      currentCap: json['currentCap'],
      maxCap: json['maxCap'],
      source: json['source'],
      destination: json['destination'],
      long: json['long'],
      lat: json['lat'],
    );
  }
}