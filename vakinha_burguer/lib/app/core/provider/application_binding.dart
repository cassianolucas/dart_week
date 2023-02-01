import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_delivery/app/core/rest_client/custom_dio.dart';

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
      ],
      child: child,
    );
  }
}
