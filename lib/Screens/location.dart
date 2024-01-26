import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GetLatLongScreen extends StatefulWidget {
  const GetLatLongScreen({Key? key}) : super(key: key);

  @override
  State<GetLatLongScreen> createState() => _GetLatLongScreenState();
}

class _GetLatLongScreenState extends State<GetLatLongScreen> {
  double? lat;
  double? long;
  String address = "";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    //LocationPermission permissionn; 
    //permissionn = await Geolocator.requestPermission();



    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      print("value $value");
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });

      getAddress(value.latitude, value.longitude);
    }).catchError((error) {
      print("Error $error");
    });
  }

  getAddress(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    if (placemarks.isNotEmpty) {
      Placemark firstPlacemark = placemarks[0];
      String street = firstPlacemark.street ?? "";
      String country = firstPlacemark.country ?? "";
      setState(() {
        address = "$street $country";
      });
    } else {
      setState(() {
        address = "No address available";
      });
    }

    for (int i = 0; i < placemarks.length; i++) {
      print("INDEX $i ${placemarks[i]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D39F2),
        centerTitle: true,
        title: const Text("Get Location"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Lat : $lat"),
            Text("Long : $long"),
            Text("Address : $address "),
            ElevatedButton(
              onPressed: getLatLong,
              child: const Text("Get Location"),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF0D39F2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}