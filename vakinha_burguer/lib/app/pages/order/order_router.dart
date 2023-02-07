import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vakinha_delivery/app/pages/order/order_controller.dart';
import 'package:vakinha_delivery/app/pages/order/order_page.dart';
import 'package:vakinha_delivery/app/repositories/order/order_repository.dart';
import 'package:vakinha_delivery/app/repositories/order/order_repository_impl.dart';

class OrderRouter {
  OrderRouter._();

  static Widget get page => MultiProvider(
        providers: [
          Provider<OrderRepository>(
            create: (context) => OrderRepositoryImpl(context.read()),
          ),
          Provider(create: (context) => OrderController(context.read())),
        ],
        child: const OrderPage(),
      );
}
