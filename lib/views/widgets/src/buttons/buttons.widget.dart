import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../../utils/utils.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.color,
  });

  final String text;
  final dynamic Function()? onTap;
  final bool isLoading;
  final Color? color;

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            dismissKeyboard(context);
            onTap?.call();
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: color ?? AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.bgDefault,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bgDefault,
                    ),
                  ),
          ),
        ),
      );
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.text,
    required this.onTap,
  });

  final String text;
  final dynamic Function()? onTap;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 20, bottom: 34),
        child: GestureDetector(
          onTap: () {
            dismissKeyboard(context);
            onTap?.call();
          },
          child: SelectableText(
            text,
            style: const TextStyle(
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
}
