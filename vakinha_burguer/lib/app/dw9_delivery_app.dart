import 'package:flutter/material.dart';
import 'package:vakinha_delivery/app/core/provider/application_binding.dart';
import 'package:vakinha_delivery/app/core/ui/theme/theme_config.dart';
import 'package:vakinha_delivery/app/pages/auth/login/login_router.dart';
import 'package:vakinha_delivery/app/pages/auth/register/register_router.dart';
import 'package:vakinha_delivery/app/pages/home/home_router.dart';
import 'package:vakinha_delivery/app/pages/product_detail/product_detail_router.dart';
import 'package:vakinha_delivery/app/pages/splash/splash_page.dart';

class DwDeliveyApp extends StatelessWidget {
  const DwDeliveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ApplicationBindging(
      child: MaterialApp(
        title: "Delivery app",
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.theme,
        routes: {
          "/": (context) => const SplashPage(),
          "/home": (context) => HomeRouter.page,
          "/productDetail": (context) => ProductDetailRouter.page,
          "/auth/login": (context) => LoginRouter.page,
          "/auth/register": (context) => RegisterRouter.page,
        },
      ),
    );
  }
}
