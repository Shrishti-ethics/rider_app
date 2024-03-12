import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rider_app/views/map_view.dart';

import '../res/colors/app_color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after 2 seconds
    Future.delayed(Duration(seconds: 4), () {
      Get.off(() => MapView()); // Use Get.off to replace the current screen
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolor,
      body: Center(
        child: Image.asset(
          'assets/gif/splash.gif', // Update with the correct path to your GIF in the assets folder
          width: 70.w, // Adjust the width as needed
          height: 70.h, // Adjust the height as needed
          fit: BoxFit.contain, // Adjust the BoxFit property as needed
        ),
      ),
    );
  }
}
