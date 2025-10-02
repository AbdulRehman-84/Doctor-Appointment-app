import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorController extends GetxController {
  var doctor = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // seedDoctors();
    fetchDoctors(); // App start pe Firestore se data uthayega
  }

  /// Fetch doctors realtime from Firestore
  void fetchDoctors() {
    _db.collection("doctors").snapshots().listen((snapshot) {
      doctor.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id; // Firestore document id
        return data;
      }).toList();
    });
  }

  // void seedDoctors() async {
  //   final initialDoctors = [
  //     {
  //       "name": "Dr. Pawan Kumar",

  //       "speciality": "Cardiologist",
  //       "rating": 4.9,
  //       "image": "assets/images/male docter 1.png",
  //       "desc":
  //           "Expert in treating heart conditions including arrhythmia, heart failure, and coronary artery disease. 10+ years of experience.",
  //       "fee": 15000,
  //       "details":
  //           "Dr. Pawan Kumar is a senior cardiologist with more than 10 years of experience. He specializes in heart failure management, angioplasty, and advanced cardiac care.",
  //     },
  //     {
  //       "name": "Dr. Wanitha Rao",
  //       "speciality": "Dentist",
  //       "rating": 4.8,
  //       "image": "assets/images/female doctor2.png",
  //       "desc":
  //           "Specializes in cosmetic dentistry, root canal treatment, and preventive dental care. Known for patient-friendly approach.",
  //       "fee": 1000,
  //       "details":
  //           "Dr. Wanitha Rao is a dentist with expertise in root canal, braces, and preventive care. She is known for painless treatment and patient comfort.",
  //     },
  //     {
  //       "name": "Dr. Udara Sen",
  //       "speciality": "Neurologist",
  //       "rating": 4.7,
  //       "image": "assets/images/male docter 4.png",
  //       "desc":
  //           "Experienced in treating neurological disorders including epilepsy, migraines, and stroke rehabilitation. 12+ years of practice.",
  //       "fee": 30000,
  //       "details":
  //           "Dr. Udara Sen is a neurologist with 12+ years of practice. He provides treatment for epilepsy, migraines, and post-stroke rehabilitation.",
  //     },
  //     {
  //       "name": "Dr. Lady Mehta",
  //       "speciality": "Pediatrician",
  //       "rating": 4.9,
  //       "image": "assets/images/lady docter.png",
  //       "desc":
  //           "Provides comprehensive healthcare for children, including vaccinations, growth monitoring, and treatment of common illnesses.",
  //       "fee": 10000,
  //       "details":
  //           "Dr. Lady Mehta is a pediatrician with experience in child growth, immunizations, and treatment of common pediatric conditions.",
  //     },
  //     {
  //       "name": "Dr. Ramesh Sharma",
  //       "speciality": "Therapist",
  //       "rating": 4.6,
  //       "image": "assets/images/ramesh.png",
  //       "desc": "Expert in physical therapy and rehabilitation.",
  //       "fee": 5000,
  //       "details":
  //           "Dr. Ramesh Sharma specializes in sports injuries and physical rehabilitation.",
  //     },
  //     {
  //       "name": "Dr. Anjali Verma",
  //       "speciality": "Surgeon",
  //       "rating": 4.8,
  //       "image": "assets/images/angali.png",
  //       "desc": "Experienced general surgeon with 15+ years of practice.",
  //       "fee": 25000,
  //       "details":
  //           "Dr. Anjali Verma specializes in abdominal and laparoscopic surgeries.",
  //     },
  //     {
  //       "name": "Dr. Vikram Singh",
  //       "speciality": "Orthopedic",
  //       "rating": 4.7,
  //       "image": "assets/images/vikram.png",
  //       "desc": "Specialist in bone and joint disorders.",
  //       "fee": 20000,
  //       "details":
  //           "Dr. Vikram Singh treats fractures, joint replacements, and sports injuries.",
  //     },
  //     {
  //       "name": "Dr. Priya Kapoor",
  //       "speciality": "Dermatologist",
  //       "rating": 4.9,
  //       "image": "assets/images/priya.png",
  //       "desc": "Expert in skin, hair, and nail disorders.",
  //       "fee": 12000,
  //       "details":
  //           "Dr. Priya Kapoor provides treatments for acne, eczema, and cosmetic dermatology.",
  //     },
  //     {
  //       "name": "Dr. Sameer Khan",
  //       "speciality": "Psychiatrist",
  //       "rating": 4.6,
  //       "image": "assets/images/sameer.png",
  //       "desc": "Specialist in mental health and counseling.",
  //       "fee": 8000,
  //       "details":
  //           "Dr. Sameer Khan provides treatment for depression, anxiety, and behavioral disorders.",
  //     },
  //     // baqi doctors yahan add karo...
  //   ];

  //   for (var doc in initialDoctors) {
  //     await _db.collection("doctors").add(doc);
  //   }
  // }
}
