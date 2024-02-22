import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mynotes/NavBar/nav_page.dart';
import 'package:mynotes/Screens/Home/main_home_screen.dart';
import 'package:mynotes/Screens/Home/temp.dart';
import 'package:mynotes/Screens/ServiceStations/list_of_servicestations.dart';
import 'package:mynotes/auth/splash_page.dart';
import 'package:mynotes/user_location/getNearestStation.dart';
import 'auth/login_page.dart';
import 'firebase_options.dart';
import 'auth/registeration_page.dart';
import 'features/authentication/screens/onboarding.dart';
import 'package:mynotes/features/splash/screen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import 'package:mynotes/utils/theme/theme.dart';

Future<void> main() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.grey.shade900,
          ),
          backgroundColor: Colors.grey.shade900,
          useMaterial3: true,
        ),
        
        initialRoute: '/',
        routes: {
          "/": (context) => SplashPagee(),
          "/login": (context) => LoginPage(),
          "/register": (context) => RegisterationPage(),
          "/home": (context) => HomeScreen(),
          "/location": (context) => locationServices(),
          "/nav": (context) => NavPage(),
          "/temp": (context) => GetLatLongScreen(),
          "/serviceCenterList": (context) => ListOfServiceStations(),
          "/onBoarding": (context) => OnBoardingScreen(),
        });
  }
}
