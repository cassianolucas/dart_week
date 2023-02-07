import 'package:vakinha_delivery/app/models/product_model.dart';

class OrderProductDto {
  final ProductModel product;
  final int amount;

  double get totalPrice => amount * product.price;

  OrderProductDto({
    required this.product,
    required this.amount,
  });

  OrderProductDto copyWith({
    ProductModel? product,
    int? amount,
  }) {
    return OrderProductDto(
      product: product ?? this.product,
      amount: amount ?? this.amount,
    );
  }
}
