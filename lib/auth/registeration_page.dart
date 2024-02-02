import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mynotes/functions/buttons.dart';
import 'package:mynotes/auth/location_function.dart';
import 'package:mynotes/globals.dart' as globals;

class RegisterationPage extends StatefulWidget {
  const RegisterationPage({Key? key}) : super(key: key);

  @override
  State<RegisterationPage> createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
  bool showLoader = false;
  DateTime created_On = DateTime.now();
  double? lat;
  double? long;
  @override
  initState() {
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

    getAddress(double lat, double long) async {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      if (placemarks.isNotEmpty) {
        Placemark firstPlacemark = placemarks[0];
        String street = firstPlacemark.street ?? "";
        String country = firstPlacemark.country ?? "";
        globals.country = country;
        globals.street = street;
      } else {
        setState(() {
          globals.street = "No address available";
          globals.country = "No address available";
        });
      }
    }

    Future<Position> data = _determinePosition();
    data.then((value) {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
      getAddress(value.latitude, value.longitude);
    }).catchError((error) {
      print("Error $error");
    });
    print(lat);
    print(long);
    super.initState();
  }

  // Format the date and time

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void RegisterUser() async {
    print("Name" + nameController.text.trim());
    print("Email" + emailController.text.trim());
    print("Password" + passwordController.text.trim());
    print("Password" + phoneController.text.trim());
    print("Created On: " + created_On.toString());

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      if (userCredential.user!.uid.isNotEmpty) {
        print("User Created Successfully: " +
            userCredential.user!.uid.toString());
        getCurrentLocation();
        FirebaseFirestore.instance
            .collection("customer")
            .doc(userCredential.user!.uid)
            .set({
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "email": emailController.text.trim(),
          "created_on": created_On.toString(),
        }).then((value) => Navigator.pushReplacementNamed(context, "/nav"));
      }

      //if(userCredential.user!.uid.isNotEmpty)
      //{
      //  Navigator.pushReplacementNamed(context, "/home");
      //}
    } on FirebaseAuthException catch (e) {
      print("Something went wrong" + e.message.toString());
      print("Error Code: " + e.code.toString());
      Navigator.pushReplacementNamed(context, "/register");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: showLoader
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center the children vertically
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(20),
                              child: Container(
                                child: Image.asset(
                                  "assets/service_cover.png",
                                  height: 15,
                                ),
                                height: 150,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              cursorColor: Color(0xFFD20606),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: "Name",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  size: 24.0,
                                  color: Color(0xFFD20606),
                                ),
                                contentPadding: EdgeInsets.all(16),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFD20606),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "Phone",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.text,
                              cursorColor: Color(0xFFD20606),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: "Phone",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  size: 24.0,
                                  color: Color(0xFFD20606),
                                ),
                                contentPadding: EdgeInsets.all(16),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFD20606),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.text,
                              cursorColor: Color(0xFFD20606),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  size: 24.0,
                                  color: Color(0xFFD20606),
                                ),
                                contentPadding: EdgeInsets.all(16),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFD20606),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              cursorColor: Color(0xFFD20606),
                              obscureText: true,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  size: 24.0,
                                  color: Color(0xFFD20606),
                                ),
                                contentPadding: EdgeInsets.all(16),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFD20606),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            "Confirm Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: confirmPasswordController,
                              keyboardType: TextInputType.text,
                              cursorColor: Color(0xFFD20606),
                              obscureText: true,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  size: 24.0,
                                  color: Color(0xFFD20606),
                                ),
                                contentPadding: EdgeInsets.all(16),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFFD20606),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: customElevatedButton(
                                text: "Register",
                                onPressed: () {
                                  if (emailController.text.isEmpty ||
                                      passwordController.text.isEmpty ||
                                      confirmPasswordController.text.isEmpty ||
                                      phoneController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("No Field could be empty"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else if (confirmPasswordController.text !=
                                      passwordController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Password incorrect!"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    print("Register");

                                    setState(() {
                                      showLoader = true;
                                    });
                                    RegisterUser();
                                  }
                                }),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Existing user? ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          customInkWell(
                            text: "Log in",
                            onTap: () {
                              Navigator.pushNamed(context, "/login");
                              print("Login");
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
