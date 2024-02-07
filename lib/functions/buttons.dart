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
        color: Color.fromARGB(255, 232, 138, 138),
      ),
    ),
    onTap: onTap,
  );
}

class ButtonTile extends StatefulWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onPressed;
  final String tag;

  const ButtonTile(
      {super.key,
      required this.tag,
      required this.imageUrl,
      required this.title,
      required this.onPressed});

  @override
  State<ButtonTile> createState() => _ButtonTileState();
}

class _ButtonTileState extends State<ButtonTile> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isHover = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isHover = false;
        });
        widget.onPressed();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 172,
        height: 149, // Fix the height of the button tile
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20.0),
          color: isHover
              ? Color.fromARGB(255, 198, 31, 19)
              : Color.fromARGB(255, 250, 250, 250),
          boxShadow: [
            BoxShadow(
                blurRadius: 8,
                spreadRadius: 3,
                color: Color.fromARGB(255, 189, 186, 185))
          ],
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100.0,
              // Adjust the height as needed
              child: Image.asset(
                widget.imageUrl,
                height: 70,
                width: 70,
                color:
                    isHover ? Color.fromARGB(255, 255, 255, 255) : Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Hero(
              tag: widget.tag,
              child: Text(
                widget.title,
                style: TextStyle(
                  color: isHover
                      ? Color.fromARGB(255, 255, 255, 255)
                      : Color.fromARGB(255, 50, 48, 48),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
