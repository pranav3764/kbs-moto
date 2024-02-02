import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mynotes/Screens/location.dart';
import 'package:mynotes/functions/buttons.dart';
import 'package:mynotes/auth/location_function.dart';
import 'package:mynotes/globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final locationServices _locationServices = locationServices();
  double? lat;
  double? long;
  String stree = "";
  String countr = "";
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
        String postalCode = firstPlacemark.postalCode ?? "";

        globals.country = country;
        globals.street = street;
        globals.postalCode = postalCode;
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

  DateTime created_On = DateTime.now();
  bool showLoader = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void loginUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print(
          "User Signed in Successfully" + userCredential.user!.uid.toString());
      // FirebaseFirestore.instance.collection("user").doc(userCredential.user!.uid).set(
      // Retrieve additional user data (such as email, name, etc.) from Firebase
      User? currentUser = FirebaseAuth.instance.currentUser;

      String uid = currentUser?.uid ?? "";

      FirebaseFirestore.instance
          .collection("user_locations")
          .doc(userCredential.user!.uid)
          .set({
        "street": stree,
        "country": countr,
        "aid": uid,
      }).then((value) => Navigator.pushReplacementNamed(context, "/nav"));

      //);
    } on FirebaseAuthException catch (e) {
      print("OHOOOO Something went wrong" + e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: showLoader
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFFD20606),
              ),
            )
          : SingleChildScrollView(
              // Wrap with SingleChildScrollView

              child: Padding(
                padding: EdgeInsets.all(25),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Stack(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(2),
                              child: Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/car_service_noBg.png",
                                  height: 300,
                                ),
                                height: 180,
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Log in",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18),
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
                              obscureText:
                                  !isPasswordVisible, // Toggle between obscure and visible text
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
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    if (!mounted) {
                                      return;
                                    }
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xFFD20606),
                                  ),
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
                            text: "Log in",
                            onPressed: () {
                              // Validate email and password fields
                              if (emailController.text.isEmpty ||
                                  passwordController.text.isEmpty) {
                                // Show an error or warning, for example, using a SnackBar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Email and password cannot be empty"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                if (!mounted) {
                                  return;
                                }
                                // Proceed with login if fields are not empty
                                setState(() {
                                  showLoader = true;
                                });
                                loginUser();
                              }

                              // Add your login functionality here
                            },
                          )),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          customInkWell(
                            text: "Register",
                            onTap: () {
                              print("Register");
                              Navigator.pushNamed(context, "/register");
                            },
                          ),
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
