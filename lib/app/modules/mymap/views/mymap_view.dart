import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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
      body: GMap(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("To the Lake"),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }
}

class GMap extends StatefulWidget {
  @override
  State<GMap> createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Completer<GoogleMapController> mapC = Completer();

  Set<Marker> myMarker = {};

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  final CameraPosition initialCamera = CameraPosition(
    target: LatLng(-6.200000, 106.816666),
    zoom: 14.4746,
  );

  Future _getLocation({LatLng? pos}) async {
    double? lat;
    double? long;
    if (pos == null) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print(position.latitude);
      print(position.longitude);
      lat = position.latitude;
      long = position.longitude;
    } else {
      lat = pos.latitude;
      long = pos.longitude;
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      Map<String, dynamic> lokasi = placemarks[0].toJson();
      print("lokasi" + lokasi.toString());
      myMarker.add(Marker(
          markerId: MarkerId("mymarker"),
          infoWindow: InfoWindow(title: lokasi["street"], snippet: "snippet"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(lat, long)));
      final GoogleMapController contrMap = await mapC.future;
      contrMap.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: 19)));
    } catch (e) {
      print("error getlocation : " + e.toString());
    }
  }

  void addMarker(LatLng pos) {
    myMarker.add(Marker(
        markerId: MarkerId("mymarker"),
        infoWindow: InfoWindow(),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos));
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: initialCamera,
      onMapCreated: (control) {
        mapC.complete(control);
      },
      markers: myMarker,
      onTap: (latlang) {
        _getLocation(pos: latlang);
        setState(() {});
      },
    );
  }
}
