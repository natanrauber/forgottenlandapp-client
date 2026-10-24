import 'package:flutter/material.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../../../core/routes.dart';
import '../../controllers/home_controller.dart';
import 'overview.dart';

class OverviewExperience extends StatefulWidget {
  @override
  State<OverviewExperience> createState() => _OverviewExperienceState();
}

class _OverviewExperienceState extends State<OverviewExperience> {
  final HomeController homeCtrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) => Obx(
        () => OverviewWidget(
          isEnabled: !homeCtrl.isLoadingOverview.value,
          isLoading: homeCtrl.isLoadingOverview.value && homeCtrl.overviewExperience.isEmpty,
          title: 'Top level',
          onTap: _onTap,
          list: homeCtrl.overviewExperience,
          customValueText: _itemValueText,
        ),
      );

  dynamic _onTap() {
    if (homeCtrl.overviewExperience.isEmpty) return homeCtrl.getOverview();
    return Get.toNamed<dynamic>('${Routes.highscores.name}/experience');
  }

  String _itemValueText(HighscoresEntry item) => item.level?.toString() ?? '';
}
