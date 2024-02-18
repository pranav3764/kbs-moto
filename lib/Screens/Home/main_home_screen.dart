// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:mynotes/Screens/ServiceStations/list_of_servicestations.dart';
// import 'package:mynotes/Screens/bookAppointment/bookAppointment.dart';
// import 'package:mynotes/functions/buttons.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mynotes/globals.dart' as globals;
// import 'package:url_launcher/url_launcher.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   double heightofbannerbox = 200.0;
//   Stream<QuerySnapshot<Map<String, dynamic>>> fetchBanners() {
//     return FirebaseFirestore.instance.collection("Banners").snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Expanded(
//                 flex: 0,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 15.0, right: 10),
//                   child: Icon(
//                     Icons.location_pin,
//                     color: Colors.red,
//                     size: 35,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 10,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 6.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         globals.street,
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF000000),
//                             fontSize: 18.0),
//                       ),
//                       Text(
//                         globals.country + ', ' + globals.postalCode,
//                         textAlign: TextAlign.left,
//                         style: TextStyle(
//                             fontWeight: FontWeight.normal,
//                             color: Color(0xFF9D9D9D),
//                             fontSize: 13.0),
//                       ),
//                       Divider(
//                         color: Color(0xFF000000),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 23),
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Container(
//                         height: heightofbannerbox,
//                         child:
//                             StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                           stream: fetchBanners(),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasError) {
//                               return Center(
//                                 child: Text('Error: ${snapshot.error}'),
//                               );
//                             }

//                             if (snapshot.connectionState ==
//                                 ConnectionState.waiting) {
//                               return Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             }

//                             final urls = snapshot.data?.docs
//                                 .map((doc) => doc.data()['url'] as String)
//                                 .toList();

//                             return CarouselSlider(
//                               options: CarouselOptions(
//                                 height: heightofbannerbox,
//                                 autoPlay: true,
//                                 enlargeCenterPage: true,
//                                 viewportFraction: 1.0,
//                               ),
//                               items: urls?.map((url) {
//                                     return Builder(
//                                       builder: (BuildContext context) {
//                                         return InkWell(
//                                           onTap: () async {
//                                             const String instagramUrl =
//                                                 'https://gomechanic.in/';
//                                             if (await launch(url)) {
//                                             } else {}
//                                           },
//                                           child: Container(
//                                             padding: EdgeInsets.all(4),
//                                             child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(18),
//                                               child: Image.network(url,
//                                                   fit: BoxFit.cover),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   }).toList() ??
//                                   [],
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),

//                   /*CarouselSlider(
//                       options: CarouselOptions(
//                         height: 30,
//                         autoPlay: true,
//                         enlargeCenterPage: true,
//                         viewportFraction: 1.0,
//                       ),
//                       items: urls?.map((url) {
//                         return Builder(
//                           builder: (BuildContext context) {
//                             return InkWell(
//                               onTap: () async {
//                                 const String instagramUrl =
//                                     'https://gomechanic.in/';
//                                 if (await launch(url)) {
//                                 } else {}
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.all(4),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(18),
//                                   child: Image.network(url, fit: BoxFit.cover),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       }).toList() ?? [],
//                     ),*/
//                   Row(children: [
//                     ButtonTile(
//                       imageUrl: 'assets/appointment.png',
//                       title: 'Book Appointment',
//                       tag: 'a',
//                       onPressed: () {
//                         // Add your button's on pressed logic here
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => BookAppointment(tag: 'a')));
//                       },
//                     ),
//                     SizedBox(width: 16),
//                     ButtonTile(
//                       imageUrl: 'assets/motorcycle.png',
//                       title: 'Vehicles',
//                       tag: 'b',
//                       onPressed: () {
//                         // Add your button's on pressed logic here
//                         print('Button pressed!');
//                       },
//                     ),
//                   ]),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   Row(children: [
//                     ButtonTile(
//                       imageUrl: 'assets/garage.png',
//                       title: 'Service Stations',
//                       tag: 'c',
//                       onPressed: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => ListOfServiceStations()));
//                       },
//                     ),
//                     SizedBox(width: 16),
//                     ButtonTile(
//                       imageUrl: 'assets/file.png',
//                       title: 'History Services',
//                       tag: 'd',
//                       onPressed: () {
//                         // Add your button's on pressed logic here
//                         print('Button pressed!');
//                       },
//                     ),
//                   ]),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/Screens/Addvehicles/add_vehicles.dart';
import 'package:mynotes/Screens/Home/myAppointments.dart';
import 'package:mynotes/Screens/ServiceStations/list_of_servicestations.dart';
import 'package:mynotes/Screens/bookAppointment/bookAppointment.dart';
import 'package:mynotes/functions/buttons.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double heightofbannerbox = 250.0;
  String customerId = globals.customerId;
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchBanners() {
    print(customerId);
    return FirebaseFirestore.instance.collection("Banners").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, right: 10),
                    child: Icon(
                      Icons.location_pin,
                      color: Color(0xFFee1c1d),
                      size: 35,
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          globals.street,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF000000),
                              fontSize: 18.0),
                        ),
                        Text(
                          globals.country + ', ' + globals.postalCode,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 97, 91, 91),
                              fontSize: 13.0),
                        ),
                        Divider(
                          color: Color(0xFF000000),
                          height: 15,
                          thickness: 0.8,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: heightofbannerbox,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: fetchBanners(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final urls = snapshot.data?.docs
                          .map((doc) => doc.data()['url'] as String)
                          .toList();

                      return CarouselSlider(
                        options: CarouselOptions(
                          height: heightofbannerbox,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                        ),
                        items: urls?.map((url) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return InkWell(
                                    onTap: () async {
                                      const String instagramUrl =
                                          'https://gomechanic.in/';
                                      if (await launch(url)) {
                                      } else {}
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.network(url,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList() ??
                            [],
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),

            /*CarouselSlider(
                    options: CarouselOptions(
                      height: 30,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                    ),
                    items: urls?.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return InkWell(
                            onTap: () async {
                              const String instagramUrl =
                                  'https://gomechanic.in/';
                              if (await launch(url)) {
                              } else {}
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(url, fit: BoxFit.cover),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList() ?? [],
                  ),*/

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ButtonTile(
                imageUrl: 'assets/appointment.png',
                title: 'Book Appointment',
                tag: 'a',
                onPressed: () {
                  // Add your button's on pressed logic here
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ListOfServiceStations()));
                },
              ),
              SizedBox(
                width: 2,
              ),
              SizedBox(
                width: 2,
              ),
              ButtonTile(
                imageUrl: 'assets/motorcycle.png',
                title: 'Vehicles',
                tag: 'b',
                onPressed: () {
                  // Add your button's on pressed logic here
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddVehicleScreen()));
                },
              ),
              SizedBox(
                width: 2,
              ),
              SizedBox(
                width: 2,
              ),
              ButtonTile(
                imageUrl: 'assets/garage.png',
                title: 'Service Stations',
                tag: 'c',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ListOfServiceStations()));
                },
              ),
              SizedBox(
                width: 2,
              ),
              SizedBox(
                width: 2,
              ),
              ButtonTile(
                imageUrl: 'assets/file.png',
                title: 'History Services',
                tag: 'd',
                onPressed: () {
                  // Add your button's on pressed logic here
                  print('Button pressed!');
                },
              ),
            ]),

            // Appointments Section
            Expanded(
              child: Container(
                child: MyAppointments(
                  customerId: globals.customerId,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
