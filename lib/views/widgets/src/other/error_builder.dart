import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';

class ErrorBuilder extends Container {
  ErrorBuilder(String text, {String? reloadButtonText, void Function()? onTapReload})
      : super(
          height: 110,
          padding: const EdgeInsets.all(30),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              if (onTapReload != null)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onTapReload,
                    child: Text(
                      reloadButtonText ?? 'Reload',
                      style: const TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
}
