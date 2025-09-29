import 'package:docterapp/controllers/appointment_controller.dart';
import 'package:docterapp/view/appointment_screens/date_time_select.dart';
import 'package:docterapp/view/payment_screen/payment_screen.dart';
import 'package:docterapp/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final AppointmentController controller = Get.put(AppointmentController());

  Map<String, dynamic>?
  selectedAppointment; //  selected date & time store karega

  @override
  Widget build(BuildContext context) {
    final doctor = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: Text(
          "Appointment",
          style: GoogleFonts.openSans(
            fontSize: 20,
            color: const Color(0xFF0B8FAC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Card
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      doctor?["image"] ?? "assets/images/male_doctor_1.png",
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                doctor?["name"] ?? "Unknown Doctor",
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: const [
                                Icon(Icons.call, color: Colors.teal),
                                SizedBox(width: 14),
                                Icon(Icons.chat, color: Colors.teal),
                                SizedBox(width: 14),
                                Icon(Icons.video_call, color: Colors.teal),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          doctor?["desc"] ?? "Specialist",
                          style: const TextStyle(color: Colors.teal),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment: ",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${doctor?["fee"] ?? 0}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Details
              Text(
                "Details",
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doctor?["details"] ?? "No details available for this doctor.",
                style: const TextStyle(color: Color(0xFF0B8FAC), fontSize: 13),
              ),

              // Doctor Card ke baad ye add kar do ↓
              const SizedBox(height: 20),

              Text(
                "Working Hours",
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                doctor?["workingHours"] ?? "09:00 AM - 05:00 PM",
                style: const TextStyle(color: Color(0xFF0B8FAC), fontSize: 13),
              ),

              const SizedBox(height: 16),

              Text(
                "Available Days",
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                doctor?["availableDays"] ?? "Monday - Friday",
                style: const TextStyle(color: Color(0xFF0B8FAC), fontSize: 13),
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 20),

              //  Selected Appointment (show karne ke liye)
              if (selectedAppointment != null) ...[
                const SizedBox(height: 10),
                Text(
                  "Your Selected Appointment:",
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Date: ${selectedAppointment!['date']}",
                  style: const TextStyle(fontSize: 14, color: Colors.teal),
                ),
                Text(
                  "Time: ${selectedAppointment!['time']}",
                  style: const TextStyle(fontSize: 14, color: Colors.teal),
                ),
              ],

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Book an Appointment",
                  onPressed: () async {
                    final result = await Get.to(
                      () => const DateTimeSelect(),
                    ); //  await
                    if (result != null) {
                      setState(() {
                        selectedAppointment = result; // save selected date+time
                      });

                      Get.snackbar(
                        "Success",
                        "Appointment set on ${result['date']} at ${result['time']}",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.teal,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 40),
              CustomButton(
                text: "Add Payment",
                onPressed: () {
                  Get.to(PaymentScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
