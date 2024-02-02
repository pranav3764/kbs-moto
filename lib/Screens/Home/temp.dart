import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetLatLongScreen extends StatefulWidget {
  const GetLatLongScreen({Key? key}) : super(key: key);

  @override
  State<GetLatLongScreen> createState() => _GetLatLongScreenState();
}

class _GetLatLongScreenState extends State<GetLatLongScreen> {
  double heightofbannerbox = 200.0; // Define your desired height here

  @override
  void initState() {
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D39F2),
        centerTitle: true,
        title: const Text("Get Location"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                                child: Image.network(url, fit: BoxFit.cover),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList() ?? [],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchBanners() {
    return FirebaseFirestore.instance.collection("Banners").snapshots();
  }
}