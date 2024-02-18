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
        margin: EdgeInsets.only(bottom: 15),
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 200),
        width: 94,
        height: 100, // Fix the height of the button tile
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 103, 101, 101).withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 9,
              offset: Offset(0, 2),
            ),
          ],
          color: isHover ? Color(0xFFee1c1d) : Colors.white,
        ),
        padding: EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40.0,
              // Adjust the height as needed
              child: Image.asset(
                widget.imageUrl,
                height: 30,
                width: 30,
                color:
                    isHover ? Color.fromARGB(255, 255, 255, 255) : Colors.black,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Hero(
              tag: widget.tag,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isHover
                      ? Color.fromARGB(255, 255, 255, 255)
                      : Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
