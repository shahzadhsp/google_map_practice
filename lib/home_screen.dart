import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Marker> _marker = [];
  final List<Marker> _list = [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(31.582045, 74.329376),
      infoWindow: InfoWindow(title: 'My position'),
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(31.582045, 74.329376),
      infoWindow: InfoWindow(title: 'Lahore Pakistan'),
    ),
    Marker(
        markerId: MarkerId('3'),
        position: LatLng(31.5883, 74.3105),
        infoWindow: InfoWindow(
          title: 'Badshahi mosque',
        )),
    Marker(
        markerId: MarkerId('4'),
        position: LatLng(31.6018, 74.3206),
        infoWindow: InfoWindow(
          title: 'Badami Bagh Lahore',
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
    loadData();
  }

  loadData() {
    getUserCurrentLocation().then((value) async {
      debugPrint('My Current Location');
      debugPrint(
          "Latitude${value.latitude.toString()}Longitude${value.longitude.toString()}");
      _marker.add(
        Marker(
            markerId: const MarkerId('2'),
            position: LatLng(value.altitude, value.longitude),
            infoWindow: const InfoWindow(title: 'My Current Location')),
      );
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.altitude, value.longitude), zoom: 14);
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error$error");
    });
    return await Geolocator.getCurrentPosition();
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
          getUserCurrentLocation().then((value) async {
            debugPrint('My Current Location');
            debugPrint(
                "Latitude${value.latitude.toString()}Longitude${value.longitude.toString()}");
            _marker.add(
              Marker(
                  markerId: const MarkerId('2'),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: const InfoWindow(title: 'My Current Location')),
            );
            CameraPosition cameraPosition = CameraPosition(
                target: LatLng(value.latitude, value.longitude), zoom: 14);
            GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
          // for update the camera position

          //GoogleMapController controller = await _controller.future;
          // controller.animateCamera(
          //   CameraUpdate.newCameraPosition(
          //     const CameraPosition(
          //       target: LatLng(31.582045, 74.329376),
          //     ),
          //   ),
          // );
        },
        child: const Icon(Icons.location_disabled_outlined),
      ),
    );
  }
}
