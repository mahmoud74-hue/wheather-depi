import 'dart:async';

import 'package:final_depi/views/home/homescreen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SplashController extends GetxController {
  // Control Variables
  // Functions

  void splashTimer() {
    Timer(
      Duration(seconds: 20),
      () {
        navigator?.push(MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      },
    );
  }
}
