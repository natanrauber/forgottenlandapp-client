import 'package:flutter/widgets.dart';

class GridButtonModel {
  GridButtonModel({
    required this.enabled,
    required this.name,
    required this.icon,
    this.shortName,
    this.onTap,
    this.resizeBy = 0,
  });

  final bool enabled;
  final String name;
  final String? shortName;
  final IconData icon;
  dynamic Function()? onTap;
  final double resizeBy;
}
