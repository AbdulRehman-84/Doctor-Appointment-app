import 'package:docterapp/view/appointment_screens/date_time_select.dart';
import 'package:docterapp/view/chat_screen/message_screen.dart';
import 'package:docterapp/view/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:docterapp/controllers/home_screen_controller.dart';
import 'home_tab.dart'; // import the separate file

class HomeScreen extends StatelessWidget {
  final homeController controller = Get.put(homeController());

  final List<Widget> pages = [
    HomeTab(),

    // AppointmentScreen(),
    DateTimeSelect(),
    MessageScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedIndex.value != 0) {
          controller.selectedIndex.value = 0; // back press -> Home tab
          return false; // app close nahi hogi
        }
        return true; // agar already home par ho to app exit ho jayegi
      },
      child: Scaffold(
        body: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: pages,
          ),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) => controller.selectedIndex.value = index,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: const Color(0xFF0B8FAC),
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
              BottomNavigationBarItem(
                icon: Icon(Icons.timelapse_rounded),
                label: "",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.message), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
            ],
          ),
        ),
      ),
    );
  }
}
