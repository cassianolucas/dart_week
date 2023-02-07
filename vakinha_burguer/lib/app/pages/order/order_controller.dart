import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:vakinha_delivery/app/dto/order_dto.dart';
import 'package:vakinha_delivery/app/dto/order_product_dto.dart';
import 'package:vakinha_delivery/app/pages/order/order_state.dart';
import 'package:vakinha_delivery/app/repositories/order/order_repository.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderController(this._orderRepository) : super(const OrderState.initial());

  void load(List<OrderProductDto> products) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));

      final paymentTypes = await _orderRepository.getAllPaymentTypes();

      emit(state.copyWith(
        orderProducts: products,
        status: OrderStatus.loaded,
        paymentTypes: paymentTypes,
      ));
    } catch (e, s) {
      log("Erro ao carregar pagina", error: e, stackTrace: s);
      emit(
        state.copyWith(
          status: OrderStatus.error,
          errorMessage: "Erro ao carregar pagina",
        ),
      );
    }
  }

  void incrementProduct(int index) {
    final orders = [...state.orderProducts];
    final order = orders[index];
    orders[index] = order.copyWith(amount: order.amount + 1);

    emit(
      state.copyWith(
        orderProducts: orders,
        status: OrderStatus.updateOrder,
      ),
    );
  }

  void decrementProduct(int index) {
    final orders = [...state.orderProducts];
    final order = orders[index];
    final amount = order.amount;

    if (amount == 1) {
      if (state.status != OrderStatus.confirmRemoveProduct) {
        emit(
          OrderConfirmDeleteProductState(
            status: OrderStatus.confirmRemoveProduct,
            orderProducts: state.orderProducts,
            errorMessage: state.errorMessage,
            paymentTypes: state.paymentTypes,
            orderProduct: order,
            index: index,
          ),
        );

        return;
      } else {
        orders.removeAt(index);
      }
    } else {
      orders[index] = order.copyWith(amount: order.amount - 1);
    }

    if (orders.isEmpty) {
      emptyBag();
      return;
    }

    emit(
      state.copyWith(
        orderProducts: orders,
        status: OrderStatus.updateOrder,
      ),
    );
  }

  void cancelDeleteProcess() {
    emit(state.copyWith(status: OrderStatus.loaded));
  }

  void emptyBag() {
    emit(state.copyWith(status: OrderStatus.emptyBag));
  }

  Future<void> saveOrder({
    required String address,
    required String document,
    required int paymentMethodId,
  }) async {
    emit(state.copyWith(status: OrderStatus.loading));

    await _orderRepository.saveOrder(
      OrderDto(
        products: state.orderProducts,
        address: address,
        document: document,
        paymentMethodId: paymentMethodId,
      ),
    );

    emit(state.copyWith(status: OrderStatus.success));
  }
}