import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/Screens/Addvehicles/field.dart';

class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  String _selectedFuelType = 'Diesel';
  String _selectedTransmissionType = 'Automatic';
  TextEditingController _brandController = TextEditingController();
  TextEditingController _modelController = TextEditingController();
  TextEditingController _variantController = TextEditingController();
  TextEditingController _kmDrivenController = TextEditingController();

  late DateTime _selectedDate;
  late User? _currentUser;
  bool pClicked = false;
  bool dClicked = false;
  bool hClicked = false;
  bool cClicked = false;
  bool eClicked = false;
  bool aClicked = false;
  bool mClicked = false;
  bool iClicked = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  // Future<void> _addVehicleToFirestore() async {
  //   try {
  //     if (_currentUser != null) {
  //       final CollectionReference vehiclesCollection = FirebaseFirestore.instance
  //           .collection('customer')
  //           .doc(_currentUser!.uid)
  //           .collection('vehicles');
  //
  //       await vehiclesCollection.add({
  //         'customerId': _currentUser!.uid,
  //         'brand': _brandController.text,
  //         'model': _modelController.text,
  //         'variant': _variantController.text,
  //         'fuelType': _selectedFuelType,
  //         'transmissionType': _selectedTransmissionType,
  //         'year': _selectedDate.year,
  //         'kmDriven': int.parse(_kmDrivenController.text),
  //         // Add other fields as needed
  //       });
  //
  //       // Clear text fields after adding vehicle
  //       _brandController.clear();
  //       _modelController.clear();
  //       _variantController.clear();
  //       _kmDrivenController.clear();
  //
  //       // Optionally, you can show a success message or navigate to another screen
  //     }
  //   } catch (error) {
  //     print('Error adding vehicle: $error');
  //     // Handle errors accordingly
  //   }
  // }

  Future<void> _addVehicleToFirestore() async {
    try {
      if (_currentUser != null) {
        final CollectionReference vehiclesCollection = FirebaseFirestore
            .instance
            .collection('customer')
            .doc(_currentUser!.uid)
            .collection('vehicles');

        DocumentReference newVehicleRef = await vehiclesCollection.add({
          'customerId': _currentUser!.uid,
          'brand': _brandController.text,
          'model': _modelController.text,
          'variant': _variantController.text,
          'fuelType': _selectedFuelType,
          'transmissionType': _selectedTransmissionType,
          'year': _selectedDate.year,
          'kmDriven': int.parse(_kmDrivenController.text),
          // Add other fields as needed
        });

        // Get the auto-generated vehicleId
        String vehicleId = newVehicleRef.id;

        // Update the document with vehicleId
        await newVehicleRef.update({'vehicleId': vehicleId});

        // Clear text fields after adding vehicle
        _brandController.clear();
        _modelController.clear();
        _variantController.clear();
        _kmDrivenController.clear();

        // Optionally, you can show a success message or navigate to another screen
      }
    } catch (error) {
      print('Error adding vehicle: $error');
      // Handle errors accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vehicle'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Field(
              name: 'Brand',
              controller: _brandController,
              hintText: "Enter Brand",
            ),
            SizedBox(
              height: 15,
            ),
            Field(
                name: 'Model',
                controller: _modelController,
                hintText: "Enter Model"),
            SizedBox(
              height: 15,
            ),
            Field(
                name: 'Variant',
                controller: _variantController,
                hintText: "Enter Variant"),

            SizedBox(
              height: 15,
            ),
            Text(
              "Fuel Type",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 108, 79, 56),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: (() {
                    setState(() {
                      _selectedFuelType = 'Petrol';
                    });
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFee1c1d),
                      ),
                      color: _selectedFuelType == 'Petrol'
                          ? Color(0xFFee1c1d)
                          : Colors.white,
                    ),
                    child: Text(
                      "Petrol",
                      style: TextStyle(
                          color: _selectedFuelType == 'Petrol'
                              ? Colors.white
                              : Color(0xFFee1c1d)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: (() {
                    setState(() {
                      _selectedFuelType = 'Diesel';
                    });
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFee1c1d),
                      ),
                      color: _selectedFuelType == 'Diesel'
                          ? Color(0xFFee1c1d)
                          : Colors.white,
                    ),
                    child: Text(
                      "Diesel",
                      style: TextStyle(
                          color: _selectedFuelType == 'Diesel'
                              ? Colors.white
                              : Color(0xFFee1c1d)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: (() {
                    setState(() {
                      _selectedFuelType = 'Hydrogen Cell';
                    });
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFee1c1d),
                      ),
                      color: _selectedFuelType == 'Hydrogen Cell'
                          ? Color(0xFFee1c1d)
                          : Colors.white,
                    ),
                    child: Text(
                      "Hydrogen",
                      style: TextStyle(
                          color: _selectedFuelType == 'Hydrogen Cell'
                              ? Colors.white
                              : Color(0xFFee1c1d)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: (() {
                    setState(() {
                      _selectedFuelType = 'CNG';
                    });
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFee1c1d),
                      ),
                      color: _selectedFuelType == 'CNG'
                          ? Color(0xFFee1c1d)
                          : Colors.white,
                    ),
                    child: Text(
                      "CNG",
                      style: TextStyle(
                          color: _selectedFuelType == 'CNG'
                              ? Colors.white
                              : Color(0xFFee1c1d)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: (() {
                    setState(() {
                      _selectedFuelType = 'Electric';
                    });
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFee1c1d),
                      ),
                      color: _selectedFuelType == 'Electric'
                          ? Color(0xFFee1c1d)
                          : Colors.white,
                    ),
                    child: Text(
                      "Electric",
                      style: TextStyle(
                          color: _selectedFuelType == 'Electric'
                              ? Colors.white
                              : Color(0xFFee1c1d)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Transmission Type",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color.fromARGB(255, 108, 79, 56),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: (() {
                    setState(() {
                      _selectedTransmissionType = 'Automatic';
                    });
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFee1c1d),
                      ),
                      color: _selectedTransmissionType == 'Automatic'
                          ? Color(0xFFee1c1d)
                          : Colors.white,
                    ),
                    child: Text(
                      "Automatic",
                      style: TextStyle(
                          color: _selectedTransmissionType == 'Automatic'
                              ? Colors.white
                              : Color(0xFFee1c1d)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: (() {
                    setState(() {
                      _selectedTransmissionType = 'Manual';
                    });
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFee1c1d),
                      ),
                      color: _selectedTransmissionType == 'Manual'
                          ? Color(0xFFee1c1d)
                          : Colors.white,
                    ),
                    child: Text(
                      "Manual",
                      style: TextStyle(
                          color: _selectedTransmissionType == 'Manual'
                              ? Colors.white
                              : Color(0xFFee1c1d)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: (() {
                    setState(() {
                      _selectedTransmissionType = 'IMT';
                    });
                  }),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFee1c1d),
                      ),
                      color: _selectedTransmissionType == 'IMT'
                          ? Color(0xFFee1c1d)
                          : Colors.white,
                    ),
                    child: Text(
                      "IMT",
                      style: TextStyle(
                          color: _selectedTransmissionType == 'IMT'
                              ? Colors.white
                              : Color(0xFFee1c1d)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            // DropdownButtonFormField<String>(
            //   value: _selectedFuelType,
            //   onChanged: (newValue) {
            //     setState(() {
            //       _selectedFuelType = newValue!;
            //     });
            //   },
            //   items: <String>[
            //     'Petrol',
            //     'Diesel',
            //     'Hydrogen Cell',
            //     'CNG',
            //     'Electric'
            //   ].map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   decoration: InputDecoration(labelText: 'Fuel Type'),
            // ),
            // DropdownButtonFormField<String>(
            //   value: _selectedTransmissionType,
            //   onChanged: (newValue) {
            //     setState(() {
            //       _selectedTransmissionType = newValue!;
            //     });
            //   },
            //   items: <String>['Automatic', 'Manual', 'IMT']
            //       .map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   decoration: InputDecoration(labelText: 'Transmission Type'),
            // ),
            Row(
              children: [
                Text(
                  'Year: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromARGB(255, 108, 79, 56),
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text('${_selectedDate.year}'),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Field(
                name: 'Kilometers Driven',
                controller: _kmDrivenController,
                hintText: "Enter Km"),

            SizedBox(height: 35.0),
            Center(
              child: ElevatedButton(
                  onPressed: () => _addVehicleToFirestore(),
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
                            'Add Vehicle',
                            style: TextStyle(fontSize: 17),
                          )))),
            ),
          ],
        ),
      ),
    );
  }
}
