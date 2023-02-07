import 'package:vakinha_delivery/app/dto/order_dto.dart';
import 'package:vakinha_delivery/app/models/payment_type_model.dart';

abstract class OrderRepository {
  Future<List<PaymentTypeModel>> getAllPaymentTypes();

  Future<void> saveOrder(OrderDto order);
}
