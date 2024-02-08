// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:math' show cos, sqrt, asin;

// import 'package:mynotes/Screens/bookAppointment/bookAppointment.dart';

// class ListOfServiceStations extends StatefulWidget {
//   const ListOfServiceStations({Key? key}) : super(key: key);

//   @override
//   State<ListOfServiceStations> createState() => _ListOfServiceStationsState();
// }

// class _ListOfServiceStationsState extends State<ListOfServiceStations> {
//   Position? _userPosition;

//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//   }

//   Future<void> _getUserLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _userPosition = position;
//       });
//     } catch (e) {
//       print("Error getting user location: $e");
//     }
//   }

//   double _calculateDistance(
//       double userLat, double userLon, double branchLat, double branchLon) {
//     const double p = 0.017453292519943295;
//     double a = 0.5 -
//         cos((branchLat - userLat) * p) / 2 +
//         cos(userLat * p) *
//             cos(branchLat * p) *
//             (1 - cos((branchLon - userLon) * p)) /
//             2;
//     return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//             backgroundColor: Colors.white,
//             body: SafeArea(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                 child: StreamBuilder(
//                   stream: FirebaseFirestore.instance
//                       .collection('admins')
//                       .doc('g64p7nddtoxBZDKEQq1V')
//                       .collection('branch')
//                       .snapshots(),
//                   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     }
//                     if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
//                       return Center(child: Text('No Data Found'));
//                     }

//                     return ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         final data = snapshot.data!.docs[index].data()
//                             as Map<String, dynamic>;
//                         double branchLat = data['location'].latitude;
//                         double branchLon = data['location'].longitude;
//                         double distance = 0.0;

//                         if (_userPosition != null) {
//                           distance = _calculateDistance(_userPosition!.latitude,
//                               _userPosition!.longitude, branchLat, branchLon);

//                         }

//                         return Container(
//                           height: 130,
//                           margin: EdgeInsets.only(bottom: 15),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.2),
//                                 spreadRadius: 5,
//                                 blurRadius: 7,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 10),
//                             child: Row(
//                               children: [
//                                 // image
//                                 imagee(),
//                                 SizedBox(width: 20),
//                                 // title and subtitle
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       data['name'],
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         Icon(
//                                           Icons.location_on,
//                                           color: Colors.grey.shade400,
//                                         ),
//                                         SizedBox(width: 5),
//                                         Text(
//                                           '${distance.toStringAsFixed(2)} km',
//                                           style: TextStyle(
//                                             color: Colors.grey.shade600,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(height: 7),
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     BookAppointment()));
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         primary: Color(0xFF7D0A0A),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(18),
//                                         ),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 8,
//                                             vertical: 4), // Adjust padding here
//                                         child: Text(
//                                           'Book Appointment',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//           );
//   }

//   Container imagee() {
//     return Container(
//       height: 130,
//       width: 100,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         image: DecorationImage(
//           image: AssetImage(
//               'assets/service_cover.png'), // Make sure to replace '.png' with the appropriate extension
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;
import '../bookAppointment/bookAppointment.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                ..sort((a, b) => (a['distance'] as double)
                    .compareTo(b['distance'] as double));
              Color selectedColour(int position) {
                Color c = Color.fromARGB(255, 229, 82, 82);
                if (position % 3 == 0) c = Color.fromARGB(255, 26, 149, 149);
                if (position % 3 == 1) c = Color.fromARGB(255, 157, 112, 29);
                if (position % 3 == 2) c = Color.fromARGB(255, 138, 32, 142);
                return c;
              }

              return ListView.builder(
                itemCount: sortedStations.length,
                itemBuilder: (context, index) {
                  final data =
                      sortedStations[index]['data'] as Map<String, dynamic>;
                  final distance = sortedStations[index]['distance'] as double;

                  return Stack(children: <Widget>[
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BookAppointment(
                          userName:
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
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedColour(index),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              // title and subtitle
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data['name'],
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '${distance.toStringAsFixed(2)} km',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     Navigator.of(context)
                                  //         .push(MaterialPageRoute(
                                  //       builder: (context) => BookAppointment(
                                  //         userName: data[
                                  //             'name'], // Pass the service center name
                                  //         selectedServiceCenterName:
                                  //             _nameController
                                  //                 .text, // Pass the user's name
                                  //         adminId:
                                  //             'g64p7nddtoxBZDKEQq1V', // Provide the adminId here
                                  //         branchId: data[
                                  //             'branchId'], // Pass the branchId from Firestore
                                  //       ),
                                  //     ));
                                  //   },
                                  //   style: ElevatedButton.styleFrom(
                                  //     primary: Color(0xFF7D0A0A),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(20),
                                  //     ),
                                  //   ),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.symmetric(
                                  //       horizontal: 8,
                                  //       vertical: 2,
                                  //     ),
                                  //     child: Text(
                                  //       'Book Appointment',
                                  //       style: TextStyle(
                                  //         color: Colors.white,
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -5,
                      left: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 2.5,
                      child: imagee(data['name'], index),
                    ),
                  ]);
                },
              );
            },
          ),
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
