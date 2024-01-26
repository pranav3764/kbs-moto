import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/functions/buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/globals.dart' as globals;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(
                Icons.location_pin,
                size: 35,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    globals.country,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: GoogleFonts.metrophobic().fontFamily,
                    ),
                  ),
                  Text(
                    globals.street,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: GoogleFonts.metrophobic().fontFamily,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(children: [
                  SizedBox(
                    height: 12,
                  ),
                  Row(children: [
                    ButtonTile(
                      imageUrl: 'assets/button_images/inspection.png',
                      title: 'Book Appointment',
                      onPressed: () {
                        // Add your button's on pressed logic here
                        print('Button pressed!');
                      },
                    ),
                    SizedBox(width: 10),
                    ButtonTile(
                      imageUrl: 'assets/button_images/cleaning.png',
                      title: 'Vehicles',
                      onPressed: () {
                        // Add your button's on pressed logic here
                        print('Button pressed!');
                      },
                    ),
                  ]),
                ]),
                Row(children: [
                  SizedBox(
                    height: 12,
                  ),
                  Row(children: [
                    ButtonTile(
                      imageUrl: 'assets/button_images/inspection.png',
                      title: 'Service Stations',
                      onPressed: () {
                        // Add your button's on pressed logic here
                        print('Button pressed!');
                      },
                    ),
                    SizedBox(width: 10),
                    ButtonTile(
                      imageUrl: 'assets/button_images/cleaning.png',
                      title: 'History Services',
                      onPressed: () {
                        // Add your button's on pressed logic here
                        print('Button pressed!');
                      },
                    ),
                  ]),
                ])
              ],
            ),
          ),
        ));
  }
}
