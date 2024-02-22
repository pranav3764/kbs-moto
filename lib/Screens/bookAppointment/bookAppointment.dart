import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import '../Home/main_home_screen.dart';

bool conBook = false;

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

Future<void> _confirmBooking(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Are you sure the details are correct"),
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
              conBook = true;
              Navigator.of(context).pop();
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
              conBook = false;
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class BookAppointment extends StatefulWidget {
  final String serviceStationName;
  final String selectedServiceCenterName;
  final String adminId; // Add adminId as a parameter
  final String branchId; // Add branchId as a parameter

  const BookAppointment({
    Key? key,
    required this.serviceStationName,
    required this.selectedServiceCenterName,
    required this.adminId, // Require adminId
    required this.branchId, // Require branchId
  }) : super(key: key);

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  String appointmentStatus = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<Map<String, dynamic>> vehicles = [];

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  Map<String, dynamic>? selectedVehicle;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    _fetchUserVehicles();
    // _generateRandomPrices();
  }

  void _fetchUserVehicles() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('customer')
            .doc(uid)
            .collection('vehicles')
            .get();

        setState(() {
          // Update the vehicles list with the fetched data
          vehicles = snapshot.docs.map((doc) => doc.data()).toList();
        });
      }
    } catch (e) {
      print('Error fetching user vehicles: $e');
    }
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
      String serviceStationName = snapshot.get('name');
      String phoneNumber = snapshot.get('phone');

      // Set the name in the text field
      _nameController.text = serviceStationName;
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
    if (selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a vehicle.'),
        ),
      );
      return; // Return early if a vehicle is not selected
    }

    // Check if the user has selected a date and time
    if (_selectedDate == null || _selectedTime == null) {
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
        String name = _nameController.text;
        String phone = _phoneController.text;
        String remarks = _remarksController.text;

        Timestamp timestamp = Timestamp.fromDate(selectedDateTime);

        String appointmentId = FirebaseFirestore.instance
            .collection('admins')
            .doc(widget.adminId)
            .collection('branch')
            .doc(widget.branchId)
            .collection('appointments')
            .doc()
            .id;

        DocumentSnapshot<Map<String, dynamic>> customerSnapshot =
            await FirebaseFirestore.instance
                .collection('customer')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();

        Map<String, dynamic> customerInfo = {
          'name': customerSnapshot.get('name'),
          'phone': customerSnapshot.get('phone'),
          'email': customerSnapshot.get('email'),
          'customerId': customerSnapshot.get('customerId'),
          'created_on': customerSnapshot.get('created_on'),
        };

        Map<String, dynamic> vehicleInfo = {
          'brand': selectedVehicle!['brand'], // Use selectedVehicle
          'fuelType': selectedVehicle!['fuelType'],
          'kmDriven': selectedVehicle!['kmDriven'],
          'model': selectedVehicle!['model'],
          'transmissionType': selectedVehicle!['transmissionType'],
          'variant': selectedVehicle!['variant'],
          'vehicleId': selectedVehicle!['vehicleId'],
          'year': selectedVehicle!['year'],
        };

        Map<String, dynamic> appointmentData = {
          'name': name,
          'phone': phone,
          'remarks': remarks,
          'timestamp': timestamp,
          'customerInfo': customerInfo,
          'vehicleInfo': vehicleInfo,
          'appointmentStatus': appointmentStatus,
          'appointmentId': appointmentId,
        };

        // Map<String, dynamic> myAppointmentData = {
        //   'remarks': remarks,
        //   'timestamp': timestamp,
        //   'appointmentStatus': appointmentStatus,
        //   'vehicleInfo': vehicleInfo,
        //   'appointmentId': appointmentId,
        // };
        Map<String, dynamic> myAppointmentData = {
          'remarks': remarks,
          'timestamp': timestamp,
          'appointmentStatus': appointmentStatus,
          'vehicleInfo': vehicleInfo,
          'appointmentId': appointmentId,
          'serviceCenterName':
              widget.serviceStationName, // Include the service center name
        };

        await FirebaseFirestore.instance
            .collection('admins')
            .doc(widget.adminId)
            .collection('branch')
            .doc(widget.branchId)
            .collection('appointments')
            .doc(appointmentId)
            .set(appointmentData);

        await FirebaseFirestore.instance
            .collection('customer')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('myAppointments')
            .doc(appointmentId)
            .set(myAppointmentData);

        print('Appointment booked successfully!');
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Booking Confirmed"),
            );
          },
        );
        Future.delayed(
          Duration(seconds: 2),
          () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/nav', (Route<dynamic> route) => false);
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error booking appointment: $e'),
        ),
      );
    }
  }

// Build dropdown menu items from fetched vehicles
  List<DropdownMenuItem<Map<String, dynamic>>> _buildDropdownMenuItems() {
    List<DropdownMenuItem<Map<String, dynamic>>> items = [];
    for (var vehicle in vehicles) {
      String brand = vehicle['brand'];
      String model = vehicle['model'];
      String displayText = '$brand $model';
      items.add(
        DropdownMenuItem(
          value: vehicle,
          child: Text(displayText),
        ),
      );
    }
    return items;
  }

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
                  height: 280,
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
                              onPressed: () {
                                if (conBook) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/nav', (Route<dynamic> route) => false);
                                } else {
                                  _dialogBuilder(context);
                                }
                              }),
                          Text(
                            widget.serviceStationName,
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
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: DropdownButtonFormField(
                value: selectedVehicle,
                items: _buildDropdownMenuItems(),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                onChanged: (value) {
                  setState(() {
                    selectedVehicle = value as Map<String, dynamic>;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Select Vehicle",
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.directions_car,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                      SizedBox(
                          width: 20), // Adjust the width as per your preference
                    ],
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(
              height: 5,
              color: const Color.fromARGB(255, 88, 87, 87),
            ),

            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: "Name",
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                      SizedBox(
                          width: 20), // Adjust the width as per your preference
                    ],
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(
              height: 5,
              color: const Color.fromARGB(255, 88, 87, 87),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                      SizedBox(
                          width: 20), // Adjust the width as per your preference
                    ],
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(
              height: 5,
              color: const Color.fromARGB(255, 88, 87, 87),
            ),
            SizedBox(height: 10),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintText: 'Date',
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.redAccent,
                            size: 30,
                          ),
                          SizedBox(
                              width:
                                  20), // Adjust the width as per your preference
                        ],
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    controller: TextEditingController(
                        text:
                            '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                    enabled: false,
                  ),
                ),
                Positioned(
                  top: 3,
                  left: MediaQuery.of(context).size.width / 1.45,
                  child: ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40))),
                      child: Ink(
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(40)),
                          child: Container(
                              width: 110,
                              height: 40,
                              alignment: Alignment.center,
                              child: const Text(
                                'Change Date',
                                style: TextStyle(fontSize: 14),
                              )))),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(
              height: 5,
              color: const Color.fromARGB(255, 88, 87, 87),
            ),
            SizedBox(height: 10),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      hintText: 'Time',
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.redAccent,
                            size: 30,
                          ),
                          SizedBox(
                              width:
                                  20), // Adjust the width as per your preference
                        ],
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    controller: TextEditingController(
                        text: '${_selectedTime.hour}:${_selectedTime.minute}'),
                    enabled: false,
                  ),
                ),
                Positioned(
                  top: 3,
                  left: MediaQuery.of(context).size.width / 1.45,
                  child: ElevatedButton(
                      onPressed: () => _selectTime(context),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40))),
                      child: Ink(
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(40)),
                          child: Container(
                              width: 110,
                              height: 40,
                              alignment: Alignment.center,
                              child: const Text(
                                'Change Time',
                                style: TextStyle(fontSize: 14),
                              )))),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(
              height: 5,
              color: const Color.fromARGB(255, 88, 87, 87),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: _remarksController,
                keyboardType: TextInputType.text,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: "Remarks",
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.note,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                      SizedBox(
                          width: 20), // Adjust the width as per your preference
                    ],
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(
              height: 5,
              color: const Color.fromARGB(255, 88, 87, 87),
            ),
            SizedBox(height: 42),
            GestureDetector(
              onTap: () async {
                print("hi");
                await _confirmBooking(context);
                if (conBook) {
                  _bookAppointment();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 12.9,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                ),
                child: Center(
                  child: Text(
                    "Confirm Booking",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
