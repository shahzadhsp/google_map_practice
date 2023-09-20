import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ConvertLatlan extends StatefulWidget {
  const ConvertLatlan({super.key});

  @override
  State<ConvertLatlan> createState() => _ConvertLatlanState();
}

class _ConvertLatlanState extends State<ConvertLatlan> {
  String stAddres = '';
  String stAdd = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert Latlan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Latlan Address from address$stAddres"),
            Text(" address from latitude and longtude$stAdd"),
            GestureDetector(
              onTap: () async {
                // From Address

                List<Location> locations =
                    await locationFromAddress("Gronausestraat 710, Enschede");
                //From Coordinates
                List<Placemark> placemarks =
                    await placemarkFromCoordinates(52.2165157, 6.9437819);
                // print(locations.last.latitude);
                // print(locations.last.longitude);
                setState(() {
                  stAddres = "${locations.last.latitude} longtude${locations.last.longitude}";
                  stAdd = "${placemarks.first.country}${placemarks.first.locality}";
                });
              },
              child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: const BoxDecoration(color: Colors.green),
                  child: const Center(child: Text('Convert'))),
            )
          ],
        ),
      ),
    );
  }
}
