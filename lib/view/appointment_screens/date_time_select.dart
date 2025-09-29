import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class DateTimeSelect extends StatefulWidget {
  const DateTimeSelect({super.key});

  @override
  State<DateTimeSelect> createState() => _DateTimeSelectState();
}

class _DateTimeSelectState extends State<DateTimeSelect> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;
  // list anyi ha
  final List<String> _timeSlots = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Select Date & Time",
          style: GoogleFonts.openSans(
            color: const Color(0xFF0B8FAC),
            fontSize: media.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(media.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // used table calneder jo ka previosu ha fluuter k a
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Color(0xFF0B8FAC),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: media.height * 0.02),

            Text(
              "Available Time Slots",
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: media.width * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((time) {
                final isSelected = _selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  selectedColor: const Color(0xFF0B8FAC),
                  onSelected: (selected) {
                    setState(() {
                      _selectedTime = selected ? time : null;
                    });
                  },
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),

            const Spacer(),
            // Set Appointment
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B8FAC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  padding: EdgeInsets.symmetric(vertical: media.height * 0.018),
                ),
                // yaha pr ab logic laga gi agr dono slect hoga tab hi aga jay ga
                onPressed: () {
                  if (_selectedDay != null && _selectedTime != null) {
                    final appointment = {
                      "date": _selectedDay!.toString(),
                      "time": _selectedTime!,
                    };
                    Get.back(
                      result: appointment,
                    ); // slect krta hi wapis appoimnet screen
                  } else {
                    Get.snackbar(
                      "Error",
                      "Please select date and time",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Color(0xFF0B8FAC),
                      colorText: Colors.white,
                    );
                  }
                },
                child: Text(
                  "Set Appointment",
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: media.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
