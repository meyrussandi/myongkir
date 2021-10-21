import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/mymap_controller.dart';

class MymapView extends GetView<MymapController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MymapView'),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: controller.kGooglePlex,
        onMapCreated: (control) {
          controller.mapC.complete(control);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToLake,
        label: Text("To the Lake"),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }
}
