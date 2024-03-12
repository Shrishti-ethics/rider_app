

import 'package:get/get.dart';
import 'package:rider_app/res/routes/routes_name.dart';
import 'package:rider_app/views/map_view.dart';

import '../../views/splash_screen.dart';


class AppRoutes {

  static appRoutes() => [
    GetPage(
      name: RouteName.splashScreen,
      page: () => SplashScreen(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 50),
    ),
    GetPage(
      name: RouteName.mapView,
      page: () => MapView(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 50),
    ),

   ];
}
