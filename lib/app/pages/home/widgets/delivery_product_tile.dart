import 'package:dw_delivery_app/app/core/extensions/formatter_extension.dart';
import 'package:dw_delivery_app/app/core/ui/style/colors.app.dart';
import 'package:dw_delivery_app/app/core/ui/style/text_styles.dart';
import 'package:dw_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw_delivery_app/app/models/product_model.dart';
import 'package:dw_delivery_app/app/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryProductTile extends StatelessWidget {
  final ProductModel product;
  final OrderProductDto? orderProduct;

  const DeliveryProductTile({
    super.key,
    required this.product,
    required this.orderProduct,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final controller = context.read<HomeController>();
        final orderProductResult = await Navigator.of(context).pushNamed(
            '/productDetail',
            arguments: {'product': product, 'order': orderProduct});

        if (orderProductResult != null) {
          controller.addOrUpdateBag(orderProductResult as OrderProductDto);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      product.name,
                      style: context.textStyles.textExtraBold
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      product.description,
                      style:
                          context.textStyles.textRegular.copyWith(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      product.price.currencyPTBR,
                      style: context.textStyles.textMedium.copyWith(
                        fontSize: 12,
                        color: context.colors.secundary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image: product.image,
                width: 100,
                height: 100,
                fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }
}
