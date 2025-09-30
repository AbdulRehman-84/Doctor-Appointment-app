import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:docterapp/controllers/appointment_controller.dart';
import 'package:docterapp/view/appointment_screens/date_time_select.dart';
import 'package:docterapp/view/payment_screen/payment_screen.dart';
import 'package:docterapp/widgets/custom_button.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final AppointmentController controller = Get.put(AppointmentController());
  Map<String, dynamic>? selectedAppointment;

  @override
  Widget build(BuildContext context) {
    final doctor = Get.arguments as Map<String, dynamic>?;

    final doctorUid = doctor?["uid"]?.toString() ?? "";
    final doctorName = doctor?["name"]?.toString() ?? "Unknown";
    final doctorFee = (doctor?["fee"] ?? 0).toDouble();
    final doctorDesc = doctor?["desc"]?.toString() ?? "Specialist";
    final doctorImage =
        doctor?["image"]?.toString() ?? "assets/images/male_doctor_1.png";

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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      doctorImage,
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
                        Text(
                          doctorName,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          doctorDesc,
                          style: const TextStyle(color: Colors.teal),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment:",
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${doctorFee.toStringAsFixed(2)}",
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

              // Selected Appointment
              if (selectedAppointment != null) ...[
                Text(
                  "Your Selected Appointment:",
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Date: ${selectedAppointment!['date'] != null ? DateFormat('dd MMM yyyy').format(selectedAppointment!['date'] as DateTime) : "Not selected"}",
                  style: const TextStyle(color: Colors.teal),
                ),
                Text(
                  "Time: ${selectedAppointment!['time'] ?? "Not selected"}",
                  style: const TextStyle(color: Colors.teal),
                ),
              ],

              const SizedBox(height: 30),

              // Book Appointment Button
              CustomButton(
                text: "Book an Appointment",
                onPressed: () async {
                  final result = await Get.to<Map<String, dynamic>>(
                    () => DateTimeSelect(),
                  );

                  // Check if user picked both date and time
                  if (result == null ||
                      result['date'] == null ||
                      result['time'] == null ||
                      result['time'].toString().isEmpty) {
                    Get.snackbar(
                      "Error",
                      "You must select a date and time",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  final DateTime selectedDate = result['date'] as DateTime;
                  final String selectedTime = result['time'].toString();

                  if (doctorUid.isEmpty ||
                      selectedDate == null ||
                      selectedTime == null ||
                      selectedTime.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Missing doctor info or date/time",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  setState(() {
                    selectedAppointment = {
                      "date": selectedDate,
                      "time": selectedTime,
                    };
                  });

                  await controller.bookAppointment(
                    doctorUid: doctorUid,
                    doctorName: doctorName,
                    date: selectedDate,
                    time: selectedTime,
                    fee: doctorFee,
                  );
                },
              ),

              const SizedBox(height: 20),

              // Payment Button
              CustomButton(
                text: "Add Payment",
                onPressed: () {
                  Get.to(() => PaymentScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
