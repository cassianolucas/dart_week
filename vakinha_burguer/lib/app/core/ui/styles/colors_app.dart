import 'package:flutter/cupertino.dart';

class ColorsApp {
  static ColorsApp? _instance;

  ColorsApp._();

  static ColorsApp get I {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  Color get primary => const Color(0xff007D21);

  Color get secondary => const Color(0xffF88B0C);
}

extension ColorsAppExtension on BuildContext {
  ColorsApp get colors => ColorsApp.I;
}
