import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:final_depi/splash/splashcontroller/splashcontroller.dart';
import 'package:final_depi/views/home/homescreen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Initialize SplashController with Get.put()
  SplashController controller = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    controller
        .splashTimer(); // Start the splash timer when the screen is created
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color.fromARGB(255, 144, 163, 211),
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content
        children: [
          Center(
            child: LottieBuilder.asset(
              'assets/Animation - 1729193096428.json', // Make sure this asset path is correct
              width: context.width *
                  0.3, // Define a specific width if needed to avoid overflow
              height: context.height * 0.3, // Define height
            ),
          ),
        ],
      ),
      nextScreen: HomePage(), // The next screen after splash
      splashIconSize: context.width * 0.2, // Control the splash icon size
      //duration: 5000, // Control the duration of the animation
    );
  }
}
