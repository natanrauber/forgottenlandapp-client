import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get.dart';

import '../../../../core/routes.dart';
import '../../../highscores/controllers/highscores_controller.dart';
import '../../controllers/home_controller.dart';
import 'overview.dart';

class OverviewOnlinetime extends StatefulWidget {
  @override
  State<OverviewOnlinetime> createState() => _OverviewOnlinetimeState();
}

class _OverviewOnlinetimeState extends State<OverviewOnlinetime> {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
  final HomeController homeCtrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) => Obx(
        () => OverviewWidget(
          isEnabled: !homeCtrl.isLoadingOverview.value,
          isLoading: homeCtrl.isLoadingOverview.value && homeCtrl.overviewOnlinetime.isEmpty,
          title: 'Online time',
          onTap: _onTap,
          list: homeCtrl.overviewOnlinetime,
          customValueText: _itemValueText,
          showBar: true,
          barColorFirst: AppColors.red,
          barColorLast: AppColors.yellow,
          topValue: _sinceServerSave,
        ),
      );

  dynamic _onTap() {
    if (homeCtrl.overviewOnlinetime.isEmpty) return homeCtrl.getOverview();
    final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
    return Get.toNamed<dynamic>('${Routes.highscores.name}/onlinetime/$timeframe');
  }

  String _itemValueText(HighscoresEntry item) => item.onlineTime ?? '';

  int get _sinceServerSave {
    final DateTime tibiaNow = DT.tibia.now();
    return tibiaNow.hour * 60 + tibiaNow.minute;
  }
}
