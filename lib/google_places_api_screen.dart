import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GooglePlacesApiScreen extends StatefulWidget {
  const GooglePlacesApiScreen({super.key});

  @override
  State<GooglePlacesApiScreen> createState() => _GooglePlacesApiScreenState();
}

class _GooglePlacesApiScreenState extends State<GooglePlacesApiScreen> {
  final TextEditingController _controller = TextEditingController();
  String _sessionToken = '12345';
  Map<String, dynamic>? _placesList;
  //  Uuid is used to get the device id
  var uuid = const Uuid();
  @override
  void initState() {
    super.initState();
    // following this line listens the value that's the user entered in the textformfield
    _controller.addListener(() {});
    onChanged();
  }

  void onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    getSuggestion(_controller.text);
  }

  // this function get the response from server
  void getSuggestion(String input) async {
    String kPLACES_API_KEY = 'AIzaSyA2TZs6bX8Nrblfn3Fkd5giHRxG9sP9LTQ';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
    print(data);
    print(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Google Api Screen '),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration:
                const InputDecoration(hintText: 'search places with name '),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: _placesList!.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async{
                    List<Location> locations =
                    await locationFromAddress("Gronausestraat 710, Enschede");
                    print(locations.last.longitude);
                    print(locations.last.latitude);

                },
                title: Text(_placesList![index]['description']),
              );
            },
          ))
        ],
      ),
    );
  }
}
