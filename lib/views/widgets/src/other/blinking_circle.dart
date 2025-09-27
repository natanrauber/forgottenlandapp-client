import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../modules/main/app_controller.dart';
import '../../../../theme/colors.dart';

class BlinkingCircle extends StatefulWidget {
  const BlinkingCircle({
    super.key,
    this.size = 10,
    this.color = AppColors.green,
  });

  final double size;
  final Color color;

  @override
  BlinkingCircleState createState() => BlinkingCircleState();
}

class BlinkingCircleState extends State<BlinkingCircle> with SingleTickerProviderStateMixin {
  final AppController appCtrl = Get.find<AppController>();

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Obx(
        () {
          if (appCtrl.isLoading.value) return _body();
          return FadeTransition(
            opacity: _animationController,
            child: _body(),
          );
        },
      );

  Widget _body() => Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
