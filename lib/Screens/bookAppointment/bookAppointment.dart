import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class BookAppointment extends StatefulWidget {
  final String tag;
  const BookAppointment({Key? key, required this.tag}) : super(key: key);

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(tag: widget.tag, child: Text('Book Appointment')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 185, 26, 26)),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Name",
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.redAccent,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Date',
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.redAccent,
                        ),
                      ),
                      controller: TextEditingController(
                          text:
                              '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectTime(context),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Time',
                        prefixIcon: Icon(
                          Icons.access_time,
                          color: Colors.redAccent,
                        ),
                      ),
                      controller: TextEditingController(
                          text:
                              '${_selectedTime.hour}:${_selectedTime.minute}'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _remarksController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Remarks",
                prefixIcon: Icon(
                  Icons.notes,
                  color: Colors.redAccent,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle booking logic
              },
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                backgroundColor: Color.fromARGB(255, 151, 22, 22),
                textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              child: Text(
                "Book",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2019, 6, 7));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }
}
