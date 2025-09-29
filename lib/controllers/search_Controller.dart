// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// class searchController extends GetxController {
// var filteredDoctors = <Map<String, dynamic>>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     filteredDoctors.assignAll(doctor); // initially show all doctors
//   }

//   void searchDoctor(String query) {
//     if (query.isEmpty) {
//       filteredDoctors.assignAll(doctor);
//     } else {
//       var results = doctor.where((doctor) =>
//           doctor["name"].toString().toLowerCase().contains(query.toLowerCase())
//       ).toList();

//       filteredDoctors.assignAll(results);
//     }
//   }
// }
