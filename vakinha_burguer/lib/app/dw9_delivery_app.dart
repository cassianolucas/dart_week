import 'package:flutter/material.dart';
import 'package:vakinha_delivery/app/core/global/global_context.dart';
import 'package:vakinha_delivery/app/core/provider/application_binding.dart';
import 'package:vakinha_delivery/app/core/ui/theme/theme_config.dart';
import 'package:vakinha_delivery/app/pages/auth/login/login_router.dart';
import 'package:vakinha_delivery/app/pages/auth/register/register_router.dart';
import 'package:vakinha_delivery/app/pages/home/home_router.dart';
import 'package:vakinha_delivery/app/pages/order/order_completed_page.dart';
import 'package:vakinha_delivery/app/pages/order/order_router.dart';
import 'package:vakinha_delivery/app/pages/product_detail/product_detail_router.dart';
import 'package:vakinha_delivery/app/pages/splash/splash_page.dart';

class DwDeliveyApp extends StatelessWidget {
  final _navKey = GlobalKey<NavigatorState>();

  DwDeliveyApp({super.key}) {
    GlobalContext.instance.navigatorKey = _navKey;
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationBindging(
      child: MaterialApp(
        title: "Delivery app",
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.theme,
        navigatorKey: _navKey,
        routes: {
          "/": (context) => const SplashPage(),
          "/home": (context) => HomeRouter.page,
          "/productDetail": (context) => ProductDetailRouter.page,
          "/auth/login": (context) => LoginRouter.page,
          "/auth/register": (context) => RegisterRouter.page,
          "/order": (context) => OrderRouter.page,
          "/order/completed": (context) => const OrderCompletedPage(),
        },
      ),
    );
  }
}
