import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class Field extends StatefulWidget {
  final String name;
  final String hintText;
  final TextEditingController controller;

  // Corrected constructor
  const Field({
    Key? key, // Use Key? instead of super.key
    required this.name,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          widget.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color.fromARGB(255, 108, 79, 56),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextField(
            controller: widget.controller,
            cursorColor: Color.fromARGB(255, 108, 79, 56),
            style: TextStyle(
              color: Color.fromARGB(255, 108, 79, 56),
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide(
                  width: 3,
                  color: Color.fromARGB(255, 18, 8, 0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide(
                  width: 3,
                  color: Color.fromARGB(255, 108, 79, 56),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
