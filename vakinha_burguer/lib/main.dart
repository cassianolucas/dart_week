import 'package:flutter/material.dart';
import 'package:vakinha_delivery/app/core/config/env/env.dart';
import 'package:vakinha_delivery/app/dw9_delivery_app.dart';

void main() async {
  await Env.I.load();

  runApp(const DwDeliveyApp());
}
