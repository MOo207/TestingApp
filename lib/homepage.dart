import 'package:flutter/material.dart';
import 'package:TestingApp/services/camera/camera.dart';
import 'package:TestingApp/services/busTrack/location.dart';
import 'package:TestingApp/services/getRequests/getRequests.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
            Tab(
              icon: Icon(Icons.archive),
            ),
             Tab(icon: Icon(Icons.add_a_photo)),
             Tab(
              icon: Icon(Icons.gps_fixed),
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: [
          GetRequests(),
          Camera(),
          Location(androidFusedLocation: true)
        ],
        controller: _tabController,
      ),
    );
  }
}