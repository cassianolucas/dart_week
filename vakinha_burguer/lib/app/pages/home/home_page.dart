import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_delivery/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_delivery/app/pages/home/home_controller.dart';
import 'package:vakinha_delivery/app/pages/home/home_state.dart';
import 'package:vakinha_delivery/app/pages/home/widgets/delivery_product_tile.dart';
import 'package:vakinha_delivery/app/pages/home/widgets/button_shopping_bag_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage, HomeController> {
  @override
  void onReady() {
    controller.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppBar(),
      body: BlocConsumer<HomeController, HomeState>(
        listener: (context, state) {
          state.status.matchAny(
            any: () => hideLoader(),
            loading: () => showLoader(),
            error: () {
              hideLoader();
              showError(state.errorMesage ?? "Erro não informado!");
            },
          );
        },
        buildWhen: (previous, current) => current.status.matchAny(
          any: () => false,
          initial: () => true,
          loaded: () => true,
        ),
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (_, index) {
                    final product = state.products[index];

                    final orders = state.shoppingBag
                        .where((order) => order.product == product);

                    return DeliveryProductTile(
                      product: product,
                      orderProductDto: orders.isNotEmpty ? orders.first : null,
                    );
                  },
                ),
              ),
              Visibility(
                visible: state.shoppingBag.isNotEmpty,
                child: ButtonShoppingBagWidget(
                  bag: state.shoppingBag,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
