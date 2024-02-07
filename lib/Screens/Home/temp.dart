import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mynotes/user_location/getNearestStation.dart';

Future<void> storeLocationInFirestore(Position location) async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;

// Check if the user is signed in
    if (currentUser != null) {
      // Access the user UID
      String uid = currentUser.uid;

      // Now you can use the UID as needed in your app
      print("User UID: $uid");
    } else {
      // Handle the case where the user is not signed in
      print("User not signed in");
    }
    await FirebaseFirestore.instance
        .collection('customer')
        .doc(currentUser!.uid)
        .collection("user_location")
        .add({
      'latitude': location.latitude,
      'longitude': location.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error storing location:$e');
  }
}

Future<void> getCurrentLocation() async {
  try {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Permission Denied");
      LocationPermission ask = await Geolocator.requestPermission();
      if (ask == LocationPermission.denied ||
          ask == LocationPermission.deniedForever) {
        print("Permission still denied");
        return; // Exit the function if permission is still denied
      }
    }

    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    print("Latitude: ${currentPosition.latitude.toString()}");
    print("Longitude: ${currentPosition.longitude.toString()}");

    // Find and print the nearest service station
    await storeLocationInFirestore(currentPosition);
    await findAndPrintNearestServiceStation(
        currentPosition.latitude, currentPosition.latitude);
  } catch (e) {
    print("Error getting current location: $e");
  }
}

Future<void> findAndPrintNearestServiceStation(
    double userLatitude, double userLongitude) async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('service_station').get();
    List<ServiceStation> serviceStations = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return ServiceStation(
        name: data['Name'] ?? '',
        latitude: data['Latitude'] ?? 0.0,
        longitude: data['Longitude'] ?? 0.0,
      );
    }).toList();

    ServiceStation nearestStation =
        findNearestServiceStation(userLatitude, userLongitude, serviceStations);
    print("Nearest Service Station: ${nearestStation.name}");
  } catch (e) {
    print("Error finding nearest service station: $e");
  }
}

ServiceStation findNearestServiceStation(double userLatitude,
    double userLongitude, List<ServiceStation> serviceStations) {
  double minDistance = double.infinity;
  ServiceStation? nearestStation;

  for (ServiceStation station in serviceStations) {
    double distance = calculateDistance(
        userLatitude, userLongitude, station.latitude, station.longitude);
    if (distance < minDistance) {
      minDistance = distance;
      nearestStation = station;
    }
  }

  if (nearestStation == null) {
    throw Exception("No service stations available");
  }

  return nearestStation;
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371.0; // Radius of the Earth in kilometers
  double dLat = radians(lat2 - lat1);
  double dLon = radians(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(radians(lat1)) * cos(radians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = R * c; // Distance in kilometers
  return distance;
}

double radians(double degree) {
  return degree * (pi / 180.0);
}

class GetLatLongScreen extends StatefulWidget {
  const GetLatLongScreen({Key? key}) : super(key: key);

  @override
  State<GetLatLongScreen> createState() => _GetLatLongScreenState();
}

class _GetLatLongScreenState extends State<GetLatLongScreen> {
  double heightofbannerbox = 200.0; // Define your desired height here

  @override
  void initState() {
    super.initState();
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
            Text("hi"),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchBanners() {
    return FirebaseFirestore.instance.collection("Banners").snapshots();
  }
}
