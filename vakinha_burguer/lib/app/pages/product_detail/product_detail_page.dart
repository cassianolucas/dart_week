import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_delivery/app/core/extensions/formatter_extensions.dart';
import 'package:vakinha_delivery/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_delivery/app/core/ui/helpers/size_extensions.dart';
import 'package:vakinha_delivery/app/core/ui/styles/text_style.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_increment_decrement_button.dart';
import 'package:vakinha_delivery/app/dto/order_product_dto.dart';
import 'package:vakinha_delivery/app/models/product_model.dart';
import 'package:vakinha_delivery/app/pages/product_detail/product_detail_controller.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final OrderProductDto? orderProductDto;

  const ProductDetailPage({
    super.key,
    required this.product,
    this.orderProductDto,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState
    extends BaseState<ProductDetailPage, ProductDetailController> {
  @override
  void initState() {
    super.initState();

    final amount = widget.orderProductDto?.amount ?? 1;

    controller.initial(amount, widget.orderProductDto != null);
  }

  void _showConfirmDelete(int amount) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: const Text("Deseja excluir o produto?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: context.textStyles.textBold.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  Navigator.of(context).pop(
                    OrderProductDto(
                      product: widget.product,
                      amount: amount,
                    ),
                  );
                },
                child: Text(
                  "Confirmar",
                  style: context.textStyles.textBold,
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.screenWidth,
            height: context.percentHeight(.4),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.product.name,
              style: context.textStyles.textExtraBold.copyWith(fontSize: 22),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Text(widget.product.description),
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Container(
                width: context.percentWidth(.5),
                height: 68,
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (context, amount) {
                    return DeliveryIncrementDecrementButton(
                      decrementTap: controller.decrement,
                      incrementTap: controller.increment,
                      amount: amount,
                    );
                  },
                ),
              ),
              Container(
                width: context.percentWidth(.5),
                height: 68,
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (context, amount) {
                    return ElevatedButton(
                      style: amount == 0
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            )
                          : null,
                      onPressed: () {
                        if (amount == 0) {
                          _showConfirmDelete(amount);
                        } else {
                          Navigator.of(context).pop(
                            OrderProductDto(
                              product: widget.product,
                              amount: amount,
                            ),
                          );
                        }
                      },
                      child: Visibility(
                        visible: amount > 0,
                        replacement: Text(
                          "Exluir produto",
                          style: context.textStyles.textExtraBold,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Adicionar",
                              style: context.textStyles.textExtraBold.copyWith(
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AutoSizeText(
                                (widget.product.price * amount).currencyPTBR,
                                maxFontSize: 13,
                                minFontSize: 5,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: context.textStyles.textExtraBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
