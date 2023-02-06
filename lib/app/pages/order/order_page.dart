import 'package:dw_delivery_app/app/core/extensions/formatter_extension.dart';
import 'package:dw_delivery_app/app/core/ui/style/text_styles.dart';
import 'package:dw_delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:dw_delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:dw_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw_delivery_app/app/models/payment_type_model.dart';
import 'package:dw_delivery_app/app/pages/order/order_controller.dart';
import 'package:dw_delivery_app/app/pages/order/order_state.dart';
import 'package:dw_delivery_app/app/pages/order/widget/order_field.dart';
import 'package:dw_delivery_app/app/pages/order/widget/order_product_tile.dart';
import 'package:dw_delivery_app/app/pages/order/widget/payment_types_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/base_state/base_state.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final formKey = GlobalKey<FormState>();
  final addressEC = TextEditingController();
  final documentEC = TextEditingController();
  int? paymentTypeid;
  final paymentTypeValid = ValueNotifier<bool>(true);

  @override
  void onReady() {
    final products =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;
    controller.load(products);
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Deseja excluir o produto ${state.orderProduct.product.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.cancelDeleteProcess();
              },
              child: Text(
                'Cancelar',
                style: context.textStyles.textBold.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.decrementProduct(state.index);
              },
              child: Text(
                'Confirmar',
                style: context.textStyles.textBold,
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          loading: () => showLoader(),
          error: () {
            hideLoader();
            showError(state.errorMessage ?? 'Erro não informado');
          },
          confirmRemoveProduct: () {
            hideLoader();
            if (state is OrderConfirmDeleteProductState) {
              _showConfirmProductDialog(state);
            }
          },
          emptyBag: () {
            showInfo(
                'Sua sacola está vazia, por favor selecione um produto para realizar seu pedido');
            Navigator.pop(context, <OrderProductDto>[]);
          },
          success: () {
            hideLoader();
            Navigator.of(context).popAndPushNamed(
              '/order/completed',
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
          appBar: DeliveryAppbar(),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(children: [
                      Text(
                        'Carrinho',
                        style: context.textStyles.textTitle,
                      ),
                      IconButton(
                        onPressed: () => controller.emptyBag(),
                        icon: Image.asset(
                          'assets/images/trashRegular.png',
                        ),
                      ),
                    ]),
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
                              ),
                              const Divider(
                                color: Colors.grey,
                              )
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
                              'Total do pedido',
                              style: context.textStyles.textExtraBold
                                  .copyWith(fontSize: 16),
                            ),
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (state) => state.totalOrder,
                              builder: (context, totalOrder) {
                                return Text(
                                  totalOrder.currencyPTBR,
                                  style: context.textStyles.textExtraBold
                                      .copyWith(fontSize: 16),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: 'Endereco de Entrega',
                        controller: addressEC,
                        validator:
                            Validatorless.required('Endereço obrigatório'),
                        hintText: 'Digite um endereço',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: 'CPF',
                        controller: documentEC,
                        validator: Validatorless.required('CPF obrigatório'),
                        hintText: 'Digite o CPF',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocSelector<OrderController, OrderState,
                          List<PaymentTypeModel>>(
                        selector: (state) => state.paymentTypes,
                        builder: (context, paymentTypes) {
                          return ValueListenableBuilder(
                            valueListenable: paymentTypeValid,
                            builder: (_, paymentTypeValidValue, child) {
                              return PaymentTypesField(
                                paymentTypes: paymentTypes,
                                valueChanged: (value) {
                                  paymentTypeid = value;
                                },
                                valid: paymentTypeValidValue,
                                valueSelected: paymentTypeid.toString(),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DeliveryButton(
                          width: double.infinity,
                          height: 48,
                          label: 'FINALIZAR',
                          onPressed: () {
                            final valid =
                                formKey.currentState?.validate() ?? false;
                            final paymentTypeSelected = paymentTypeid != null;
                            paymentTypeValid.value = paymentTypeSelected;

                            if (valid & paymentTypeSelected) {
                              controller.saveOrder(
                                address: addressEC.text,
                                document: documentEC.text,
                                paymentMethodId: paymentTypeid!,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
