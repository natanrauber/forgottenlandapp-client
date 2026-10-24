import 'package:flutter/material.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../../../core/routes.dart';
import '../../../highscores/controllers/highscores_controller.dart';
import '../../controllers/home_controller.dart';
import 'overview.dart';

class OverviewExperience extends StatefulWidget {
  @override
  State<OverviewExperience> createState() => _OverviewExperienceState();
}

class _OverviewExperienceState extends State<OverviewExperience> {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
  final HomeController homeCtrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) => Obx(
        () => OverviewWidget(
          isEnabled: !homeCtrl.isLoadingOverview.value && homeCtrl.overviewExperience.isNotEmpty,
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
