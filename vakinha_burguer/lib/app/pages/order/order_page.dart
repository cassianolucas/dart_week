import 'package:flutter/material.dart';
import 'package:vakinha_delivery/app/core/ui/styles/text_style.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_delivery/app/dto/order_product_dto.dart';
import 'package:vakinha_delivery/app/models/product_model.dart';
import 'package:vakinha_delivery/app/pages/order/widget/order_field.dart';
import 'package:vakinha_delivery/app/pages/order/widget/order_product_tile.dart';
import 'package:vakinha_delivery/app/pages/order/widget/payment_types_fields.dart';
import 'package:validatorless/validatorless.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Text(
                    "Carrinho",
                    style: context.textStyles.textTitle,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/imagez/trashRegular.png",
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 2,
              (context, index) {
                return Column(
                  children: [
                    OrderProductTile(
                      index: index,
                      product: OrderProductDto(
                        product: ProductModel.fromMap({}),
                        amount: 1,
                      ),
                    ),
                    const Divider(color: Colors.grey),
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        "Total do pedido",
                        style: context.textStyles.textExtraBold.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        r"R$ 200,00",
                        style: context.textStyles.textBold.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),
                OrderField(
                  title: "Endereço de entrega",
                  controller: TextEditingController(),
                  validator: Validatorless.required("m"),
                  hintText: "Digite um endereço",
                ),
                const SizedBox(height: 10),
                OrderField(
                  title: "Cpf",
                  controller: TextEditingController(),
                  validator: Validatorless.required("m"),
                  hintText: "Digite o cpf",
                ),
                const SizedBox(height: 10),
                PaymentTypesField(),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DeliveryButton(
                          width: double.infinity,
                          heigth: 42,
                          label: "Finalizar",
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
