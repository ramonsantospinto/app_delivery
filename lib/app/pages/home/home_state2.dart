// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:match/match.dart';
import 'package:dw_delivery_app/app/dto/order_product_dto.dart';
import '../../models/product_model.dart';
part 'home_state2.g.dart';

@match
enum HomeStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class HomeState2 extends Equatable {
  final HomeStateStatus status;
  final List<ProductModel> products;
  final String? errorMessage;
  final List<OrderProductDto> shoppingBag;

  const HomeState2({
    required this.status,
    required this.products,
    required this.shoppingBag,
    this.errorMessage,
  });

  const HomeState2.initial()
      : status = HomeStateStatus.initial,
        products = const [],
        shoppingBag = const [],
        errorMessage = null;

  @override
  List<Object?> get props => [status, products, errorMessage, shoppingBag];

  HomeState2 copyWith({
    HomeStateStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
    List<OrderProductDto>? shoppingBag,
  }) {
    return HomeState2(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      shoppingBag: shoppingBag ?? this.shoppingBag,
    );
  }
}
