import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dw_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw_delivery_app/app/repositories/products/products_repository.dart';
import 'home_state2.dart';

class HomeController extends Cubit<HomeState2> {
  final ProductsRepository _productsRepository;

  HomeController(
    this._productsRepository,
  ) : super(const HomeState2.initial());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: HomeStateStatus.loading));
    try {
      final products = await _productsRepository.findAllProducts();
      emit(state.copyWith(status: HomeStateStatus.loaded, products: products));
    } catch (e, s) {
      log('Error ao buscar produtos', error: e, stackTrace: s);
      emit(
        state.copyWith(
            status: HomeStateStatus.error,
            errorMessage: 'Error ao buscar produtos'),
      );
    }
  }

  void addOrUpdateBag(OrderProductDto orderProduct) {
    final shoppingBag = [...state.shoppingBag];
    final orderIndex = shoppingBag
        .indexWhere((orderP) => orderP.product == orderProduct.product);
    if (orderIndex > -1) {
      if (orderProduct.amount == 0) {
        shoppingBag.removeAt(orderIndex);
      } else {
        shoppingBag[orderIndex] = orderProduct;
      }
    } else {
      shoppingBag.add(orderProduct);
    }

    emit(state.copyWith(shoppingBag: shoppingBag));
  }

  void updateBag(List<OrderProductDto> updateBag) {
    emit(state.copyWith(shoppingBag: updateBag));
  }
}
