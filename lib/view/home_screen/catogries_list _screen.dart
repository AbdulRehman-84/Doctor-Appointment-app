import 'package:docterapp/controllers/docter_list_controllers.dart';
import 'package:docterapp/view/appointment_screens/appointment_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorListScreen extends StatelessWidget {
  final String category;

  DoctorListScreen({super.key, required this.category});
  final DoctorController _controller = Get.put(DoctorController());
  var hours = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
  ].obs;

  @override
  Widget build(BuildContext context) {
    // filter methods
    final filteredDoctors = _controller.doctor
        .where((doc) => doc['speciality'] == category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          category,
          style: GoogleFonts.openSans(
            color: Color(0xFF7BC1B7),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredDoctors.length,
        itemBuilder: (context, index) {
          final doctor = filteredDoctors[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image ko fixed size do
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    doctor["image"],
                    width: 100, // Fixed width
                    height: 150, // Fixed height
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                //  Expanded column (text, desc, buttons etc.)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doctor["name"],
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Color(0xFF7BC1B7),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        doctor["desc"]?.toString() ?? "No description",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.to(
                                () => AppointmentScreen(),
                                arguments: doctor,
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF0B8FAC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("Book"),
                          ),
                          const Spacer(), //  baki space push karega
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "⭐ ",
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                TextSpan(
                                  text: doctor["rating"]?.toString() ?? "0.0",
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
