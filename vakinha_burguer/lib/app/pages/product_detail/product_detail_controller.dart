import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailController extends Cubit<int> {
  late final bool _hasHorder;

  ProductDetailController() : super(1);

  void initial(int amount, bool hasOrder) {
    _hasHorder = hasOrder;
    emit(amount);
  }

  void increment() => emit(state + 1);

  void decrement() {
    if (state > (_hasHorder ? 0 : 1)) {
      emit(state - 1);
    }
  }
}
