import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class homeController extends GetxController {
  //bottmbar ka var
  var selectedIndex = 0.obs;
  var categories = <String>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // addDefaultCategories();
    fetchCategories();
  }

  /// Firestore se categories fetch karna
  Future<void> fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("categories")
          .get();

      categories.assignAll(
        snapshot.docs.map((doc) => doc["name"].toString()).toList(),
      );
    } catch (e) {
      print("Error Fetching Categories: $e");
    } finally {
      isLoading.value = false; // stop loading
    }
  }

  /// Default categories firestore me add karna (sirf ek dafa chalana hai)
  Future<void> addDefaultCategories() async {
    final defaultCategories = [
      "Cardiologist",
      "Dentist",
      "Neurologist",
      "Pediatrician",
      "Therapist",
      "Surgeon",
      "Orthopedic",
      "Dermatologist",
      "Psychiatrist",
    ];

    final collection = FirebaseFirestore.instance.collection("categories");

    for (var cat in defaultCategories) {
      await collection.add({"name": cat});
    }

    // add hone ke baad dobara fetch kar lo
    await fetchCategories();
  }
  //catogry list
  // var categories = [
  //   "Cardiologist", // match Dr. Pawan Kumar
  //   "Dentist", // match Dr. Wanitha Rao
  //   "Neurologist", // match Dr. Udara Sen
  //   "Pediatrician", // match Dr. Lady Mehta
  //   "Therapist",
  //   "Surgeon",
  //   "Orthopedic",
  //   "Dermatologist",
  //   "Psychiatrist",
  // ].obs;

  //all docterlist Controler
  var doctors = [
    {
      "name": "Dr. Pawan Kumar",
      "speciality": "Cardiologist",
      "rating": 4.9,
      "image": "assets/images/male docter 1.png",
      "desc":
          "Expert in treating heart conditions including arrhythmia, heart failure, and coronary artery disease. 10+ years of experience.",
      "fee": 15000,
      "details":
          "Dr. Pawan Kumar is a senior cardiologist with more than 10 years of experience. He specializes in heart failure management, angioplasty, and advanced cardiac care.",
    },
  ].obs;
}
