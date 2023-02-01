import 'package:equatable/equatable.dart';
import 'package:match/match.dart';
import 'package:vakinha_delivery/app/dto/order_product_dto.dart';
import 'package:vakinha_delivery/app/models/product_model.dart';

part "home_state.g.dart";

@match
enum HomeStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class HomeState extends Equatable {
  final HomeStateStatus status;
  final List<ProductModel> products;
  final String? errorMesage;
  final List<OrderProductDto> shoppingBag;

  const HomeState(
    this.status,
    this.products,
    this.errorMesage,
    this.shoppingBag,
  );

  const HomeState.initial()
      : status = HomeStateStatus.initial,
        products = const [],
        errorMesage = null,
        shoppingBag = const [];

  @override
  List<Object?> get props => [
        status,
        products,
        errorMesage,
        shoppingBag,
      ];

  HomeState copyWith({
    HomeStateStatus? status,
    List<ProductModel>? products,
    String? errorMesage,
    List<OrderProductDto>? shoppingBag,
  }) {
    return HomeState(
      status ?? this.status,
      products ?? this.products,
      errorMesage ?? this.errorMesage,
      shoppingBag ?? this.shoppingBag,
    );
  }
}
