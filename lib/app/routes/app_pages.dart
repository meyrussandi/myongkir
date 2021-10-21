import 'package:get/get.dart';

import 'package:myongkir/app/modules/cost/bindings/cost_binding.dart';
import 'package:myongkir/app/modules/cost/views/cost_view.dart';
import 'package:myongkir/app/modules/home/bindings/home_binding.dart';
import 'package:myongkir/app/modules/home/views/home_view.dart';
import 'package:myongkir/app/modules/mymap/bindings/mymap_binding.dart';
import 'package:myongkir/app/modules/mymap/views/mymap_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MYMAP,
      page: () => MymapView(),
      binding: MymapBinding(),
    ),
    GetPage(
      name: _Paths.COST,
      page: () => CostView(),
      binding: CostBinding(),
    ),
  ];
}
