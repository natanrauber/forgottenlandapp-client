import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../../../core/routes.dart';
import '../../../highscores/controllers/highscores_controller.dart';
import '../../controllers/home_controller.dart';
import 'overview.dart';

class OverviewExpgain extends StatefulWidget {
  @override
  State<OverviewExpgain> createState() => _OverviewExpgainState();
}

class _OverviewExpgainState extends State<OverviewExpgain> {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
  final HomeController homeCtrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) => Obx(
        () => OverviewWidget(
          isEnabled: !homeCtrl.isLoadingOverview.value,
          isLoading: homeCtrl.isLoadingOverview.value && homeCtrl.overviewExpgain.isEmpty,
          title: 'Exp gained',
          onTap: _onTap,
          list: homeCtrl.overviewExpgain,
          customValueText: _itemValueText,
          showBar: true,
          barColorFirst: AppColors.green,
          barColorLast: AppColors.yellow,
        ),
      );

  dynamic _onTap() {
    if (homeCtrl.overviewExpgain.isEmpty) return homeCtrl.getOverview();
    final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
    return Get.toNamed<dynamic>('${Routes.highscores.name}/experiencegained/$timeframe');
  }

  String _itemValueText(HighscoresEntry item) => '+${item.stringValue ?? ''}';
}
