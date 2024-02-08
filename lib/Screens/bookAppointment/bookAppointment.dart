import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

import '../Home/main_home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:mynotes/Screens/Home/main_home_screen.dart';

// class BookAppointment extends StatefulWidget {
//   final String tag;
//   const BookAppointment({Key? key, required this.tag}) : super(key: key);

//   @override
//   State<BookAppointment> createState() => _BookAppointmentState();
// }

// class _BookAppointmentState extends State<BookAppointment> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _remarksController = TextEditingController();

//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _selectedTime = TimeOfDay.now();

//   @override
//   Widget build(BuildContext context) {
//     booking() {
//       print(_selectedDate);
//     }

//     Future<void> _selectDate(BuildContext context) async {
//       print("hi");
//       final DateTime? picked = await DatePicker.showDatePicker(context,
//           showTitleActions: true,
//           minTime: DateTime.now(),
//           maxTime: DateTime(2100, 6, 7));
//       if (picked != null && picked != _selectedDate)
//         setState(() {
//           _selectedDate = picked;
//         });
//     }

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Are you sure you don't want to book a appointment"),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/nav', (Route<dynamic> route) => false);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('No',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//     return Scaffold(
//       appBar: AppBar(
//         title: Hero(tag: widget.tag, child: Text('Book Appointment')),
//         leading: IconButton(
//             icon:
//                 Icon(Icons.arrow_back, color: Color.fromARGB(255, 185, 26, 26)),
//             onPressed: () => _dialogBuilder(context)),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: _nameController,
//               keyboardType: TextInputType.text,
//               decoration: InputDecoration(
//                 hintText: "Name",
//                 prefixIcon: Icon(
//                   Icons.person,
//                   color: Colors.redAccent,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => _selectDate(context),
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         hintText: 'Date',
//                         prefixIcon: Icon(
//                           Icons.calendar_today,
//                           color: Colors.redAccent,
//                         ),
//                       ),
//                       controller: TextEditingController(
//                           text:
//                               '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => _selectTime(context),
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         hintText: 'Time',
//                         prefixIcon: Icon(
//                           Icons.access_time,
//                           color: Colors.redAccent,
//                         ),
//                       ),
//                       controller: TextEditingController(
//                           text:
//                               '${_selectedTime.hour}:${_selectedTime.minute}'),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               controller: _remarksController,
//               keyboardType: TextInputType.multiline,
//               maxLines: null,
//               decoration: InputDecoration(
//                 hintText: "Remarks",
//                 prefixIcon: Icon(
//                   Icons.notes,
//                   color: Colors.redAccent,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 booking();
//               },
//               style: ElevatedButton.styleFrom(
//                 shape: StadiumBorder(),
//                 padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//                 backgroundColor: Color.fromARGB(255, 151, 22, 22),
//                 textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//               ),
//               child: Text(
//                 "Book",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//     );
//     if (picked != null && picked != _selectedTime)
//       setState(() {
//         _selectedTime = picked;
//       });
//   }
// }

class BookAppointment extends StatefulWidget {
  final String userName;
  final String selectedServiceCenterName;
  final String adminId; // Add adminId as a parameter
  final String branchId; // Add branchId as a parameter

  const BookAppointment({
    Key? key,
    required this.userName,
    required this.selectedServiceCenterName,
    required this.adminId, // Require adminId
    required this.branchId, // Require branchId
  }) : super(key: key);

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  double _totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    // _generateRandomPrices();
  }

  void _fetchCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      // Fetch user data from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('customer')
          .doc(uid)
          .get();

      // Retrieve the 'name' field from Firestore
      String userName = snapshot.get('name');
      String phoneNumber = snapshot.get('phone');

      // Set the name in the text field
      _nameController.text = userName;
      _phoneController.text = phoneNumber;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  void _bookAppointment() async {
    // Check if the user has selected a date and time
    if (_selectedDate == null || _selectedTime == null) {
      // Show a message to the user indicating that both date and time need to be selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select both date and time.'),
        ),
      );
      return;
    }

    // Get the selected date and time
    DateTime selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Calculate the end time (30 minutes later)
    DateTime endTime = selectedDateTime.add(Duration(minutes: 30));

    try {
      // Query Firestore to check for existing appointments within the selected time slot
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('admins')
          .doc(widget.adminId)
          .collection('branch')
          .doc(widget.branchId)
          .collection('appointments')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                  selectedDateTime.subtract(Duration(minutes: 30))))
          .where('timestamp',
              isLessThanOrEqualTo:
                  Timestamp.fromDate(endTime.add(Duration(minutes: 30))))
          .get();

      // If there are any appointments within the selected time slot, show a message
      if (snapshot.docs.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Slots Full'),
              content: Text('All slots are full. Please try a different time.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Perform booking process here
        // You can access the selected date, time, name, and remarks
        String name = _nameController.text;
        String phone = _phoneController.text;
        String remarks = _remarksController.text;
        Timestamp timestamp = Timestamp.fromDate(selectedDateTime);

        // Create a new appointment document ID
        String appointmentId = FirebaseFirestore.instance
            .collection('admins')
            .doc(widget.adminId) // Use widget.adminId
            .collection('branch')
            .doc(widget.branchId) // Use widget.branchId
            .collection('appointments')
            .doc()
            .id;

        // Fetch customer data using the customer ID
        DocumentSnapshot<Map<String, dynamic>> customerSnapshot =
            await FirebaseFirestore.instance
                .collection('customer')
                .doc(FirebaseAuth.instance.currentUser!
                    .uid) // Fetch data for the current user
                .get();

        // Create a map for customer information
        Map<String, dynamic> customerInfo = {
          'name': customerSnapshot.get('name'),
          'phone': customerSnapshot.get('phone'),
          'email': customerSnapshot.get('email'),
          'customerId': customerSnapshot.get('customerId'),
          'created_on': customerSnapshot.get('created_on'),
          // Add more customer information if needed
        };

        // Create data to be stored in Firestore
        Map<String, dynamic> appointmentData = {
          'name': name,
          'phone': phone,
          'remarks': remarks,
          'timestamp': timestamp,
          'customerInfo': customerInfo, // Add customer information map
        };

        // Store the appointment data in Firestore
        await FirebaseFirestore.instance
            .collection('admins')
            .doc(widget.adminId)
            .collection('branch')
            .doc(widget.branchId)
            .collection('appointments')
            .doc(appointmentId)
            .set(appointmentData);

        // Print a success message
        print('Appointment booked successfully!');
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Booking Confirmed"),
              );
            });
      }
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/nav', (Route<dynamic> route) => false);
      });
    } catch (e) {
      // Show an error message to the user if the booking process fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error booking appointment: $e'),
        ),
      );
    }
  }

  // void _bookAppointment() async {
  //   // Perform booking process here
  //   // You can access the selected date, time, name, and remarks
  //   String name = _nameController.text;
  //   String phone = _phoneController.text;
  //   String remarks = _remarksController.text;
  //   Timestamp timestamp = Timestamp.now();

  //   // Create a new appointment document ID
  //   String appointmentId = FirebaseFirestore.instance
  //       .collection('admins')
  //       .doc(widget.adminId) // Use widget.adminId
  //       .collection('branch')
  //       .doc(widget.branchId) // Use widget.branchId
  //       .collection('appointments')
  //       .doc()
  //       .id;

  //   try {
  //     // Fetch customer data using the customer ID
  //     DocumentSnapshot<Map<String, dynamic>> customerSnapshot =
  //         await FirebaseFirestore.instance
  //             .collection('customer')
  //             .doc(FirebaseAuth
  //                 .instance.currentUser!.uid) // Fetch data for the current user
  //             .get();

  //     // Create a map for customer information
  //     Map<String, dynamic> customerInfo = {
  //       // 'customerName': customerSnapshot.get('name'),
  //       // 'customerPhone': customerSnapshot.get('phone'),
  //       'name': customerSnapshot.get('name'),
  //       'phone': customerSnapshot.get('phone'),
  //       'email': customerSnapshot.get('email'),
  //       'customerId': customerSnapshot.get('customerId'),
  //       'created_on': customerSnapshot.get('created_on'),
  //       // Add more customer information if needed
  //     };

  //     // Create data to be stored in Firestore
  //     Map<String, dynamic> appointmentData = {
  //       'name': name,
  //       'phone': phone,
  //       'remarks': remarks,
  //       'timestamp': timestamp,
  //       'customerInfo': customerInfo, // Add customer information map
  //     };

  //     // Store the appointment data in Firestore
  //     await FirebaseFirestore.instance
  //         .collection('admins')
  //         .doc(widget.adminId)
  //         .collection('branch')
  //         .doc(widget.branchId)
  //         .collection('appointments')
  //         .doc(appointmentId)
  //         .set(appointmentData);

  //     // Print a success message
  //     print('Appointment booked successfully!');
  //   } catch (e) {
  //     // Print an error message if the booking process fails
  //     print('Error booking appointment: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display personalized greeting message

            Stack(
              children: <Widget>[
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                        image: AssetImage('assets/service.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.arrow_back,
                                  color: Color.fromARGB(255, 185, 26, 26)),
                              onPressed: () => _dialogBuilder(context)),
                          Text(
                            widget.userName,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Name",
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.redAccent,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.redAccent,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                ),
              ),
            ),
            //
            // Other form fields and widgets...
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Date',
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.redAccent,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        controller: TextEditingController(
                            text:
                                '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                        enabled: false,
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Time',
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: Colors.redAccent,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        controller: TextEditingController(
                            text:
                                '${_selectedTime.hour}:${_selectedTime.minute}'),
                        enabled: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _remarksController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: "Remarks",
                    prefixIcon: Icon(
                      Icons.note,
                      color: Colors.redAccent,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent),
                    )),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                  onPressed: () => _bookAppointment(),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                  child: Ink(
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 236, 131, 131),
                            Color.fromARGB(255, 228, 35, 35)
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      child: Container(
                          width: 140,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text(
                            'Book',
                            style: TextStyle(fontSize: 17),
                          )))),
            )
          ],
        ),
      ),
    );
  }
}
