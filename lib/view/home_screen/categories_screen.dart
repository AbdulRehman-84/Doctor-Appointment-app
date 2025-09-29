import 'package:docterapp/controllers/docter_list_controllers.dart';
import 'package:docterapp/view/appointment_screens/appointment_Screen.dart';
import 'package:docterapp/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesDocterScreen extends StatelessWidget {
  const CategoriesDocterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // yaha apna controller ko call karo (example)
    final controller = Get.put(DoctorController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Doctors",
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0B8FAC),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomTextField(
              label: "",
              hint: "Search a Doctor",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: const Icon(Icons.mic, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
          ),

          // listview
          Expanded(
            child: Obx(
              () => controller.doctor.isEmpty
                  ? const Center(child: CircularProgressIndicator()) // loading
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.doctor.length,
                      itemBuilder: (context, index) {
                        final doc = controller.doctor[index];
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
                              //  image firestore se URL ho to Image.network() use karna
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child:
                                    doc["image"] != null &&
                                        doc["image"].toString().startsWith(
                                          "http",
                                        )
                                    ? Image.network(
                                        doc["image"],
                                        height: 150,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        doc["image"] ??
                                            "assets/images/male_doctor_1.png",
                                        height: 150,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            doc["name"]?.toString() ??
                                                "Unknown",
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
                                          icon: Icon(
                                            Icons.favorite_border,
                                            color: Color(0xFF7BC1B7),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      doc["desc"]?.toString() ??
                                          "No description",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Get.to(
                                              () => AppointmentScreen(),
                                              arguments: doc,
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Color(0xFF0B8FAC),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: Text(
                                            "Book",
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
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
                                                text:
                                                    doc["rating"]?.toString() ??
                                                    "0.0",
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
            ),
          ),
        ],
      ),
    );
  }
}
