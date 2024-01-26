import 'package:flutter/material.dart';

Widget customElevatedButton({
  required String text,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFD20606),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      alignment: Alignment.center,
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
  );
}

Widget customInkWell({
  required String text,
  required VoidCallback onTap,
}) {
  return InkWell(
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFFD20606),
      ),
    ),
    onTap: onTap,
  );
}

class ButtonTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onPressed;

  ButtonTile(
      {required this.imageUrl, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 183.0,
        height: 180.0, // Fix the height of the button tile
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100.0, // Adjust the height as needed
              child: Image.asset(
                imageUrl,
                width: double
                    .infinity, // Image takes up the entire width of the container
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
