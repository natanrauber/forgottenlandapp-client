import 'package:flutter/material.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../../../core/routes.dart';
import '../../controllers/home_controller.dart';
import 'overview.dart';

class OverviewRookmaster extends StatefulWidget {
  @override
  State<OverviewRookmaster> createState() => _OverviewRookmasterState();
}

class _OverviewRookmasterState extends State<OverviewRookmaster> {
  final HomeController homeCtrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) => Obx(
        () => OverviewWidget(
          isEnabled: !homeCtrl.isLoadingOverview.value,
          isLoading: homeCtrl.isLoadingOverview.value && homeCtrl.overviewRookmaster.isEmpty,
          title: 'Rook Master',
          onTap: _onTap,
          list: homeCtrl.overviewRookmaster,
          customValueText: _itemValueText,
        ),
      );

  dynamic _onTap() {
    if (homeCtrl.overviewRookmaster.isEmpty) return homeCtrl.getOverview();
    return Get.toNamed<dynamic>('${Routes.highscores.name}/rookmaster');
  }

  String _itemValueText(HighscoresEntry item) => item.stringValue ?? '';
}
