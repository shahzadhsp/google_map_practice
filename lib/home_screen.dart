import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Marker> _marker = [];
  final List<Marker> _list = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(31.582045, 74.329376),
      infoWindow: InfoWindow(title: 'My position'),
    ),
    const Marker(
        markerId: MarkerId('2'),
        position: LatLng(25.42796133580664, 80.885749655962),
        infoWindow: InfoWindow(
          title: 'nepal',
        )),
  ];
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.582045, 74.329376),
    zoom: 14.4746,
  );
  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Google map '),
      ),
      body: SafeArea(
        child: GoogleMap(
          markers: Set<Marker>.of(_marker),
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
          mapType: MapType.normal,
          compassEnabled: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                  target: LatLng(31.582045, 74.329376), ),
            ),
          );
        },
        child: const Icon(Icons.location_disabled_outlined),
      ),
    );
  }
}
