import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child:Column( 
       mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(image),
          height: 100, // Adjust the height as per your requirement
          width: 100, // Adjust the width as per your requirement
        ),
        SizedBox(height: 16),
        Text(
          title,
          style:  TextStyle(
            color: Colors.black,
            fontFamily: GoogleFonts.poppins().fontFamily, // Change text color to black
            fontSize: 30.0,
            fontWeight: FontWeight.bold // Adjust the font size as per your requirement
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          subTitle, // Replace with your description
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: Colors.black, // Change text color to black
            fontSize: 20, // Adjust the font size as per your requirement
          ),
          textAlign: TextAlign.center,
        ),
      ],
      ),
    );
  }
}
