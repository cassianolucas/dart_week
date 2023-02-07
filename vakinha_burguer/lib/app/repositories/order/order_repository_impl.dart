import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:vakinha_delivery/app/core/exceptions/repository_exceptios.dart';
import 'package:vakinha_delivery/app/core/rest_client/custom_dio.dart';
import 'package:vakinha_delivery/app/dto/order_dto.dart';
import 'package:vakinha_delivery/app/models/payment_type_model.dart';
import 'package:vakinha_delivery/app/repositories/order/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final CustomDio _dio;

  OrderRepositoryImpl(this._dio);

  @override
  Future<List<PaymentTypeModel>> getAllPaymentTypes() async {
    try {
      final result = await _dio.auth().get("/payment-types");

      return result.data
          .map<PaymentTypeModel>((p) => PaymentTypeModel.fromMap(p))
          .toList();
    } on DioError catch (e, s) {
      log("Erro ao buscar formas de pagametno", error: e, stackTrace: s);

      throw RepositoryException(message: "Erro ao buscar formas de pagamento");
    }
  }

  @override
  Future<void> saveOrder(OrderDto order) async {
    try {
      await _dio.auth().post(
        '/orders',
        data: {
          'products': order.products
              .map((e) => {
                    'id': e.product.id,
                    'amount': e.amount,
                    'total_price': e.totalPrice,
                  })
              .toList(),
          'user_id': '#userAuthRef',
          'address': order.address,
          'CPF': order.document,
          'payment_method_id': order.paymentMethodId,
        },
      );
    } on DioError catch (e, s) {
      log('Erro ao salvar pedido', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao salvar pedido');
    }
  }
}
