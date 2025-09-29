import 'package:get/get.dart';

class AppointmentController extends GetxController {
  // Dummy hours list
  var hours = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
  ].obs;

  // Dummy dates list
  var dates = ["sun 18", "Mon 19", "Tue 20", "Wed 21", "Thu 22", "Fri 23"].obs;

  // Selected values
  var selectedHour = "".obs;
  var selectedDate = "".obs;

  // Select Hour
  void selectHour(String hour) {
    selectedHour.value = hour;
  }

  // Select Date
  void selectDate(String date) {
    selectedDate.value = date;
  }
}
