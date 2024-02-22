import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class MyAppointments extends StatefulWidget {
  final String customerId;

  MyAppointments({required this.customerId}); // Corrected constructor syntax

  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  } // Added missing closing parenthesis

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'My Appointments',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('customer')
            .doc(widget.customerId)
            .collection('myAppointments')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No appointments found.'),
            );
          }
          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> appointmentData =
                  document.data() as Map<String, dynamic>;

              String brand = appointmentData['vehicleInfo']['brand'];
              String model = appointmentData['vehicleInfo']['model'];
              String displayText = '$brand $model';

              // Extract timestamp
              Timestamp timestamp = appointmentData['timestamp'];

              DateTime dateTime =
                  timestamp.toDate(); // Convert Timestamp to DateTime

              // Format the DateTime to a human-readable string
              String formattedDateTime =
                  DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);

              // Extract day and date separately
              String formattedTime = DateFormat('kk:mm').format(dateTime);

              String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
              String dayOfWeek = DateFormat('EEEE').format(dateTime);
              String datee = DateFormat.MMMEd().format(dateTime);

              String date = formattedDate.split('-')[2];
              String currentDate =
                  DateTime.now().toString().split(" ")[0].split("-")[2];

              String appointmentStatus = appointmentData['appointmentStatus'] ??
                  'Appointment Status Not Available';
              final diffDate = dateTime.difference(DateTime.now()).inDays;

              return Container(
                height: MediaQuery.of(context).size.height / 8,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 15),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black))),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,

                      width: 80,
                      height: 95, // Fix the height of the button tile
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 103, 101, 101)
                                .withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 9,
                            offset: Offset(0, 2),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${diffDate.toString()}",
                            style: TextStyle(
                                fontSize: 38,
                                color: Color(0xFFee1c1d),
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            "days left",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 60, 57, 57)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 17,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${displayText}",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  // Text(
                                  //   "Vehicle:",
                                  //   style: TextStyle(
                                  //       fontSize: 12,
                                  //       color:
                                  //           Color.fromARGB(255, 143, 141, 141)),
                                  // ),
                                  Text(
                                    "${datee}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Status: ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 60, 57, 57)),
                                  ),
                                  Text(
                                    "${appointmentStatus}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFee1c1d),
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Time - ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 60, 57, 57)),
                                  ),
                                  Text(
                                    "${formattedTime}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // title: Text(
                //   displayText,
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                // ),
                // subtitle: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       'Day: $dayOfWeek',
                //       style: TextStyle(fontSize: 16.0),
                //     ),
                //     Text(
                //       'Date: $formattedDate',
                //       style: TextStyle(fontSize: 16.0),
                //     ),
                //     Text(
                //       'Time: ${formattedDateTime.split(' – ')[1]}', // Extracting only time
                //       style: TextStyle(fontSize: 16.0),
                //     ),
                //     Text(
                //       'Appointment Status: $appointmentStatus',
                //       style: TextStyle(fontSize: 16.0),
                //     ),
                // ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
