import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakinha_delivery/app/core/extensions/formatter_extensions.dart';
import 'package:vakinha_delivery/app/core/ui/base_state/base_state.dart';
import 'package:vakinha_delivery/app/core/ui/styles/text_style.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_appbar.dart';
import 'package:vakinha_delivery/app/core/ui/widgets/delivery_button.dart';
import 'package:vakinha_delivery/app/dto/order_product_dto.dart';
import 'package:vakinha_delivery/app/models/payment_type_model.dart';
import 'package:vakinha_delivery/app/pages/order/order_controller.dart';
import 'package:vakinha_delivery/app/pages/order/order_state.dart';
import 'package:vakinha_delivery/app/pages/order/widget/order_field.dart';
import 'package:vakinha_delivery/app/pages/order/widget/order_product_tile.dart';
import 'package:vakinha_delivery/app/pages/order/widget/payment_types_fields.dart';
import 'package:validatorless/validatorless.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _adressController;
  late final TextEditingController _documentController;
  int? paymentTypeId;
  late final ValueNotifier<bool> _paymentTypeValidade;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _adressController = TextEditingController();
    _documentController = TextEditingController();

    _paymentTypeValidade = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _adressController.dispose();
    _documentController.dispose();

    _paymentTypeValidade.dispose();

    super.dispose();
  }

  @override
  void onReady() {
    final products =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;

    controller.load(products);
  }

  void _showConfirmDeleteProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text(
              "Deseja remover o produto ${state.orderProduct.product.name}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.cancelDeleteProcess();
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
                controller.decrementProduct(state.index);
              },
              child: Text(
                "Confirmar",
                style: context.textStyles.textBold,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmEmptyBag() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Deseja remover todos os itens do carrinho?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.cancelDeleteProcess();
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
                controller.emptyBag();
                Navigator.of(context).pop();
              },
              child: Text(
                "Confirmar",
                style: context.textStyles.textBold,
              ),
            ),
          ],
        );
      },
    );
  }

  void _finish() {
    final isValid = _formKey.currentState?.validate() ?? false;

    final paymentTypeSelected = paymentTypeId != null;

    _paymentTypeValidade.value = paymentTypeSelected;

    if (isValid && paymentTypeSelected) {
      controller.saveOrder(
        address: _adressController.text,
        document: _documentController.text,
        paymentMethodId: paymentTypeId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
          any: hideLoader,
          loading: showLoader,
          error: () {
            hideLoader();
            showError(state.errorMessage ?? "Erro não informado");
          },
          confirmRemoveProduct: () {
            hideLoader();
            if (state is OrderConfirmDeleteProductState) {
              _showConfirmDeleteProductDialog(state);
            }
          },
          emptyBag: () {
            showInfo(
              "Seu carrinho está vazio, por favor selecione um produto para realizar um pedido",
            );
            Navigator.of(context).pop(<OrderProductDto>[]);
          },
          success: () {
            hideLoader();
            Navigator.of(context).popAndPushNamed(
              "/order/completed",
              result: <OrderProductDto>[],
            );
          },
        );
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(controller.state.orderProducts);
          return false;
        },
        child: Scaffold(
          appBar: DeliveryAppBar(),
          body: Form(
            key: _formKey,
            child: CustomScrollView(
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
                          onPressed: _showConfirmEmptyBag,
                          icon: Image.asset(
                            "assets/images/trashRegular.png",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocSelector<OrderController, OrderState,
                    List<OrderProductDto>>(
                  selector: (state) => state.orderProducts,
                  builder: (context, orderProducts) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: orderProducts.length,
                        (context, index) {
                          final orderProduct = orderProducts[index];

                          return Column(
                            children: [
                              OrderProductTile(
                                index: index,
                                orderProduct: orderProduct,
                                incrementTap: controller.incrementProduct,
                                decrementTap: controller.decrementProduct,
                              ),
                              const Divider(color: Colors.grey),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total do pedido",
                              style: context.textStyles.textExtraBold.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (state) => state.totalOrder,
                              builder: (context, totalOrder) {
                                return Text(
                                  totalOrder.currencyPTBR,
                                  style: context.textStyles.textBold.copyWith(
                                    fontSize: 20,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      OrderField(
                        title: "Endereço de entrega",
                        controller: _adressController,
                        validator:
                            Validatorless.required("Endereço obrigatório"),
                        hintText: "Digite um endereço",
                      ),
                      const SizedBox(height: 10),
                      OrderField(
                        title: "Cpf",
                        controller: _documentController,
                        validator: Validatorless.required("Cpf obrigatório"),
                        hintText: "Digite o cpf",
                      ),
                      const SizedBox(height: 10),
                      BlocSelector<OrderController, OrderState,
                          List<PaymentTypeModel>>(
                        selector: (state) => state.paymentTypes,
                        builder: (context, paymentTypes) {
                          return ValueListenableBuilder(
                            valueListenable: _paymentTypeValidade,
                            builder: (_, paymentTypeValidadeValue, child) {
                              return PaymentTypesField(
                                paymentTypes: paymentTypes,
                                valueChanged: (value) => paymentTypeId = value,
                                validate: paymentTypeValidadeValue,
                                valueSelected: paymentTypeId.toString(),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: DeliveryButton(
                        label: "Finalizar",
                        width: double.infinity,
                        onPressed: _finish,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
