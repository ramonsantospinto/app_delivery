// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:dw_delivery_app/app/core/ui/style/colors.app.dart';
import 'package:dw_delivery_app/app/core/ui/style/text_styles.dart';

class DeliveryIncrementDecrementButton extends StatelessWidget {
  final bool _compact;
  final int amout;
  final VoidCallback incrementTap;
  final VoidCallback decrementTap;
  const DeliveryIncrementDecrementButton({
    super.key,
    required this.amout,
    required this.incrementTap,
    required this.decrementTap,
  }) : _compact = false;

  const DeliveryIncrementDecrementButton.compact({
    super.key,
    required this.amout,
    required this.incrementTap,
    required this.decrementTap,
  }) : _compact = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _compact ? const EdgeInsets.all(5) : null,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            onTap: decrementTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                '-',
                style: context.textStyles.textMedium
                    .copyWith(fontSize: _compact ? 10 : 22, color: Colors.grey),
              ),
            ),
          ),
          Text(
            amout.toString(),
            style: context.textStyles.textRegular.copyWith(
              fontSize: _compact ? 13 : 17,
              color: context.colors.secundary,
            ),
          ),
          InkWell(
            onTap: incrementTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                '+',
                style: context.textStyles.textMedium.copyWith(
                    fontSize: _compact ? 10 : 22,
                    color: context.colors.secundary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
