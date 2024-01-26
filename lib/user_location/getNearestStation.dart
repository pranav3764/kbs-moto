import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class locationServices extends StatefulWidget {
  const locationServices({Key? key}) : super(key: key);

  @override
  State<locationServices> createState() => _locationServicesState();
}

class _locationServicesState extends State<locationServices> {
  late List<ServiceStation> serviceStations;

  @override
  void initState() {
    super.initState();
    // Fetch service station data from Firebase
    getServiceStations();
  }

  void getServiceStations() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('service_station').get();
      serviceStations = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ServiceStation(
          name: data['Name'] ?? '',
          latitude: data['Latitude'] ?? 0.0,
          longitude: data['Longitude'] ?? 0.0,
        );
      }).toList();

      setState(() {
        // Update the state to trigger a rebuild with the fetched data
      });
    } catch (e) {
      print("Error fetching service stations: $e");
    }
  }

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      print("Permission Denied");
      LocationPermission ask = await Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      print("Latitude: ${currentPosition.latitude.toString()}");
      print("Longitude: ${currentPosition.longitude.toString()}");

      ServiceStation nearestStation = findNearestServiceStation(currentPosition.latitude, currentPosition.longitude);
      print("Nearest Service Station: ${nearestStation.name}");
    }
  }

  ServiceStation findNearestServiceStation(double userLatitude, double userLongitude) {
    double minDistance = double.infinity;

    ServiceStation? nearestStation; // Declare as nullable
    for (ServiceStation station in serviceStations) {
      double distance = calculateDistance(userLatitude, userLongitude, station.latitude, station.longitude);
      if (distance < minDistance) {
        minDistance = distance;
        nearestStation = station;
      }
    }
    // Check if nearestStation is null, handle accordingly
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Page"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              getCurrentLocation();
            },
            child: Text("Find Nearest Service Station"),
          ),
        ),
      ),
    );
  }
}

class ServiceStation {
  final String name;
  final double latitude;
  final double longitude;

  ServiceStation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}
