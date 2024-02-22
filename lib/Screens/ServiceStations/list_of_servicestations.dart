import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;
import '../bookAppointment/bookAppointment.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ListOfServiceStations extends StatefulWidget {
  const ListOfServiceStations({Key? key}) : super(key: key);

  @override
  State<ListOfServiceStations> createState() => _ListOfServiceStationsState();
}

class _ListOfServiceStationsState extends State<ListOfServiceStations> {
  Position? _userPosition;
  TextEditingController _nameController =
      TextEditingController(); // Add this line

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _userPosition = position;
      });
    } catch (e) {
      print("Error getting user location: $e");
    }
  }

  double _calculateDistance(
      double userLat, double userLon, double branchLat, double branchLon) {
    const double p = 0.017453292519943295;
    double a = 0.5 -
        cos((branchLat - userLat) * p) / 2 +
        cos(userLat * p) *
            cos(branchLat * p) *
            (1 - cos((branchLon - userLon) * p)) /
            2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('admins')
              .doc('g64p7nddtoxBZDKEQq1V')
              .collection('branch')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No Data Found'));
            }

            List<Map<String, dynamic>> sortedStations = snapshot.data!.docs
                .map<Map<String, dynamic>>((doc) {
              final data = doc.data() as Map<String, dynamic>;
              double branchLat = data['location'].latitude;
              double branchLon = data['location'].longitude;
              double distance = 0.0;

              // if (_userPosition != null) {
              //   distance = _calculateDistance(
              //   distance = _calculateDistance(
              //       _userPosition!.latitude,
              //       _userPosition!.longitude,
              //       branchLat,
              //       branchLon),
              // };
              print(data['name']);
              if (_userPosition != null) {
                distance = _calculateDistance(_userPosition!.latitude,
                    _userPosition!.longitude, branchLat, branchLon);
              }

              return {
                'data': data,
                'distance': distance,
              };
            }).toList()
              // Sort the list based on distance
              ..sort((a, b) =>
                  (a['distance'] as double).compareTo(b['distance'] as double));
            IconData? selectedColour(String name) {
              if (name == "Kbs Chandigarh Branch") {
                return MdiIcons.alphaCCircleOutline;
              } else if (name == " Kbs Mumbai Branch") {
                return MdiIcons.alphaMCircleOutline;
              } else if (name == "Kbs Delhi Branch") {
                return MdiIcons.alphaDCircleOutline;
              }
            }

            return ListView.builder(
              itemCount: sortedStations.length,
              itemBuilder: (context, index) {
                final data =
                    sortedStations[index]['data'] as Map<String, dynamic>;
                final distance = sortedStations[index]['distance'] as double;

                return distance == 0
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BookAppointment(
                            serviceStationName:
                                data['name'], // Pass the service center name
                            selectedServiceCenterName:
                                _nameController.text, // Pass the user's name
                            adminId:
                                'g64p7nddtoxBZDKEQq1V', // Provide the adminId here
                            branchId: data[
                                'branchId'], // Pass the branchId from Firestore
                          ),
                        )),
                        child: Container(
                          height: 130,
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 103, 101, 101)
                                    .withOpacity(0.2),
                                spreadRadius: 4,
                                blurRadius: 9,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Image.asset("assets/images.jpg"),
                                      SizedBox(width: 18),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            data['name'],
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFee1c1d)),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: Color(0xFFee1c1d),
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                '${distance.toStringAsFixed(2)} km',
                                                style: TextStyle(
                                                  color: Color(0xFFee1c1d),
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                      );
              },
            );
          },
        ),
      ),
    );
  }

  Container imagee(String path, int index) {
    final name = path.split(" ")[1];

    return Container(
      height: 150,
      width: 140,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage(
              'assets/${name}.png'), // Make sure to replace '.png' with the appropriate extension
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
