import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';

class WebImage extends StatelessWidget {
  const WebImage(
    this.src, {
    this.fit = BoxFit.contain,
    this.height,
    this.width,
    this.borderRadius = BorderRadius.zero,
    this.borderThickness = 0,
    this.borderColor = AppColors.bgDefault,
    this.backgroundColor = AppColors.bgDefault,
  });

  final String? src;
  final BoxFit fit;
  final double? height;
  final double? width;
  final BorderRadiusGeometry borderRadius;
  final double borderThickness;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(borderThickness),
        height: height,
        width: _width,
        decoration: BoxDecoration(
          color: borderColor,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: src == null
              ? _placeHolder()
              : ColoredBox(
                  color: backgroundColor,
                  child: Image.network(
                    src!,
                    fit: fit,
                  ),
                ),
        ),
      );

  double? get _width {
    if (width != null) return width;
    if (height != null) return (16 / 9) * (height! - borderThickness);
    return null;
  }

  Widget _placeHolder() => Center(
        child: Container(
          color: AppColors.bgDefault,
        ),
      );
}
