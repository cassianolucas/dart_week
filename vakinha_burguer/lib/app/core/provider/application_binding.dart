import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_delivery/app/core/rest_client/custom_dio.dart';
import 'package:vakinha_delivery/app/repositories/auth/auth_repository.dart';
import 'package:vakinha_delivery/app/repositories/auth/auth_repository_impl.dart';

class ApplicationBindging extends StatelessWidget {
  final Widget child;

  const ApplicationBindging({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => CustomDio(),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(dio: context.read()),
        ),
      ],
      child: child,
    );
  }
}
