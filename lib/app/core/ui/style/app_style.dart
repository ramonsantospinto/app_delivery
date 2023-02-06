import 'package:dw_delivery_app/app/core/ui/style/colors.app.dart';
import 'package:dw_delivery_app/app/core/ui/style/text_styles.dart';
import 'package:flutter/material.dart';

class AppStyle {
  static AppStyle? _instance;

  AppStyle._();
  static AppStyle get i {
    _instance ??= AppStyle._();
    return _instance!;
  }

  ButtonStyle get primaryBotton => ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        backgroundColor: ColorsApp.i.primary,
        textStyle: TextStyles.i.textButtonLevel,
      );
}

extension AppStylesExtensions on BuildContext {
  AppStyle get appStyle => AppStyle.i;
}
