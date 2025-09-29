import 'package:docterapp/view/Auth%20Screen/login_screen.dart';
import 'package:docterapp/view/Auth%20Screen/signup_screen.dart';
import 'package:docterapp/view/Auth%20Screen/splash_screen.dart';
import 'package:docterapp/view/home_screen/home_screen.dart';
// 👈 add homescreen
import 'package:get/get.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';

  static final pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignUpScreen()),
    GetPage(name: home, page: () => HomeScreen()),
  ];
}
