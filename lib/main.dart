import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rider_app/res/colors/app_color.dart';
import 'package:rider_app/res/routes/routes.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          //themeMode: Provider.of<ThemeChange>(context).thememode,
          theme: ThemeData(
              fontFamily: "SFPro-Rounded",
              brightness: Brightness.light,
              primarySwatch: Colors.indigo,
              scaffoldBackgroundColor: AppColors.backgroundcolor,
              appBarTheme: AppBarTheme(
                  color: AppColors.backgroundcolor.withOpacity(1),
                  iconTheme: const IconThemeData(
                      color: Colors.black
                  ))
          ),
          getPages: AppRoutes.appRoutes(),
        );

      },
      maxMobileWidth: 400,
    );
  }
}

