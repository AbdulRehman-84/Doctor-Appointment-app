import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var favoriteDoctors = <String>{}.obs; // doctor IDs ka set

  void toggleFavorite(String doctorId) {
    if (favoriteDoctors.contains(doctorId)) {
      favoriteDoctors.remove(doctorId);
    } else {
      favoriteDoctors.add(doctorId);
    }
  }

  bool isFavorite(String doctorId) {
    return favoriteDoctors.contains(doctorId);
  }
}
