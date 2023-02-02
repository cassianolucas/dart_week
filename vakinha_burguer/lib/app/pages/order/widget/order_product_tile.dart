import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vakinha_delivery/app/core/extensions/formatter_extensions.dart';
import 'package:vakinha_delivery/app/core/ui/styles/colors_app.dart';
import 'package:vakinha_delivery/app/core/ui/styles/text_style.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_increment_decrement_button.dart';
import 'package:vakinha_delivery/app/dto/order_product_dto.dart';

class OrderProductTile extends StatelessWidget {
  final int index;
  final OrderProductDto product;

  const OrderProductTile({
    super.key,
    required this.index,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.network(
            product.product.image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.product.name,
                  style: context.textStyles.textRegular.copyWith(fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.totalPrice.currencyPTBR,
                      style: context.textStyles.textMedium.copyWith(
                        fontSize: 14,
                        color: context.colors.secondary,
                      ),
                    ),
                    DeliveryIncrementDecrementButton.compact(
                      amount: product.amount,
                      incrementTap: () {},
                      decrementTap: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
