import 'package:flutter/material.dart';

class ClickableContainer extends StatefulWidget {
  const ClickableContainer({
    super.key,
    this.enabled = true,
    this.onTap,
    this.child,
    this.color,
    this.hoverColor,
    this.height,
    this.width,
    this.constraints,
    this.padding,
    this.margin,
    this.alignment,
    this.decoration,
  });

  final bool enabled;
  final void Function()? onTap;
  final Widget? child;
  final Color? color;
  final Color? hoverColor;
  final double? height;
  final double? width;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final BoxDecoration? decoration;

  @override
  State<ClickableContainer> createState() => _ClickableContainerState();
}

class _ClickableContainerState extends State<ClickableContainer> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
        child: InkWell(
          onTap: widget.enabled ? widget.onTap : null,
          onHover: (bool value) => setState(() => _hover = value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: widget.height,
            width: widget.width,
            constraints: widget.constraints,
            padding: widget.padding,
            margin: widget.margin,
            alignment: widget.alignment,
            decoration: (widget.decoration ?? const BoxDecoration()).copyWith(
              color: _hover ? widget.hoverColor : widget.color,
            ),
            child: widget.child,
          ),
        ),
      );
}
