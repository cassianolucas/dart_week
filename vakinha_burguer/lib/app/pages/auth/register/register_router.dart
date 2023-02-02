import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_delivery/app/pages/auth/register/register_controller.dart';
import 'package:vakinha_delivery/app/pages/auth/register/register_page.dart';

class RegisterRouter {
  RegisterRouter._();

  static Widget get page => MultiProvider(
        providers: [
          Provider(
            create: (context) => RegisterController(context.read()),
          ),
        ],
        child: const RegisterPage(),
      );
}
