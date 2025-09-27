import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatefulWidget {
  const SvgImage({
    this.height,
    this.width,
    this.asset,
    this.icon,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.transparent,
    this.iconSize,
    this.radius = 0,
  });

  final double? height;
  final double? width;
  final String? asset;
  final Color backgroundColor;
  final IconData? icon;
  final Color iconColor;
  final double? iconSize;
  final double radius;

  @override
  State<SvgImage> createState() => _SvgImageState();
}

class _SvgImageState extends State<SvgImage> {
  Future<bool> assetExists(String? path) async {
    if (path == null) return false;
    try {
      await rootBundle.loadString(path);
      return true;
    } catch (_) {}
    return false;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
        future: assetExists(widget.asset),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == true) {
            return SvgPicture.asset(
              widget.asset!,
              height: widget.height,
              width: widget.width,
            );
          }

          return Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            child: widget.icon == null
                ? Container()
                : LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraint) => Icon(
                      widget.icon,
                      size: constraint.biggest.width <= constraint.biggest.height
                          ? constraint.biggest.width * 0.60
                          : constraint.biggest.height * 0.60,
                      color: widget.iconColor,
                    ),
                  ),
          );
        },
      );
}
