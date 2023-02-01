import 'package:flutter/material.dart';
import 'package:vakinha_delivery/app/core/ui/styles/colors_app.dart';
import 'package:vakinha_delivery/app/core/ui/styles/text_style.dart';

class AppStyles {
  static AppStyles? _instance;

  AppStyles._();

  static AppStyles get I {
    _instance ??= AppStyles._();
    return _instance!;
  }

  ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        backgroundColor: ColorsApp.I.primary,
        textStyle: TextStyles.I.textButtonLabel,
      );
}

extension AppStylesExtensions on BuildContext {
  AppStyles get appStyles => AppStyles.I;
}
