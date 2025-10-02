import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../../../core/routes.dart';
import '../../../highscores/controllers/highscores_controller.dart';
import '../../../shared/views/widgets/other/blinking_circle.dart';
import '../../controllers/home_controller.dart';

class OverviewOnlinetime extends StatefulWidget {
  @override
  State<OverviewOnlinetime> createState() => _OverviewOnlinetimeState();
}

class _OverviewOnlinetimeState extends State<OverviewOnlinetime> {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
  final HomeController homeCtrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(),
          const SizedBox(height: 3),
          _body(),
        ],
      );

  Widget _title() => Container(
        height: 22,
        padding: const EdgeInsets.only(left: 3),
        child: const SelectableText(
          'Online time',
          style: TextStyle(
            fontSize: 14,
            height: 22 / 14,
          ),
        ),
      );

  Widget _body() => Obx(
        () => ShimmerLoading(
          isLoading: homeCtrl.overviewOnlinetime.isEmpty && homeCtrl.isLoading.value,
          child: ClickableContainer(
            enabled: _isEnabled,
            height: 143,
            onTap: homeCtrl.overviewOnlinetime.isEmpty
                ? homeCtrl.getOverview
                : () async {
                    final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
                    return Get.toNamed('${Routes.highscores.name}/onlinetime/$timeframe');
                  },
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            alignment: Alignment.centerLeft,
            color: AppColors.bgPaper,
            hoverColor: AppColors.bgHover,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Builder(
              builder: (_) {
                if (homeCtrl.overviewOnlinetime.isEmpty && homeCtrl.isLoading.value) return _loading();
                if (homeCtrl.overviewOnlinetime.isEmpty) return _reloadButton();
                if (homeCtrl.overviewOnlinetime.isNotEmpty) return _listBuilder();
                return Container();
              },
            ),
          ),
        ),
      );

  bool get _isEnabled {
    if (homeCtrl.isLoading.value && homeCtrl.overviewOnlinetime.isEmpty) return false;
    return true;
  }

  Widget _reloadButton() => Center(
        child: Container(
          height: 125,
          width: 125,
          padding: const EdgeInsets.all(42.5),
          child: Icon(
            Icons.refresh,
            size: 40,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
        ),
      );

  Widget _loading() => Center(
        child: Container(
          height: 125,
          width: 125,
          padding: const EdgeInsets.all(50),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ),
      );

  Widget _listBuilder() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (homeCtrl.overviewOnlinetime.isNotEmpty) _item(homeCtrl.overviewOnlinetime[0]),
          if (homeCtrl.overviewOnlinetime.length >= 2) _item(homeCtrl.overviewOnlinetime[1]),
          if (homeCtrl.overviewOnlinetime.length >= 3) _item(homeCtrl.overviewOnlinetime[2]),
          if (homeCtrl.overviewOnlinetime.length >= 4) _item(homeCtrl.overviewOnlinetime[3]),
          if (homeCtrl.overviewOnlinetime.length >= 5) _item(homeCtrl.overviewOnlinetime[4]),
        ],
      );

  Widget _item(HighscoresEntry item) => Container(
        height: 19,
        margin: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: <Widget>[
            Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                _itemRank(item),
                if (item.isOnline && !homeCtrl.isLoading.value) _onlineIndicator(),
              ],
            ),
            const SizedBox(width: 2),
            _itemName(item),
            const SizedBox(width: 2),
            _itemValue(item),
          ],
        ),
      );

  Widget _itemRank(HighscoresEntry item) => Text(
        '${item.rank}.',
        style: TextStyle(
          fontSize: 12,
          height: 19 / 12,
          color: item.isOnline && !homeCtrl.isLoading.value
              ? Colors.transparent
              : AppColors.textSecondary.withValues(alpha: 0.5),
        ),
      );

  Widget _onlineIndicator() => const Padding(
        padding: EdgeInsets.only(bottom: 1),
        child: BlinkingCircle(),
      );

  Widget _itemName(HighscoresEntry item) => Expanded(
        child: Text(
          item.name ?? '',
          maxLines: 1,
          style: const TextStyle(
            fontSize: 12,
            height: 19 / 12,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );

  Widget _itemValue(HighscoresEntry item) => BetterText(
        _itemValueText(item),
        selectable: false,
        style: TextStyle(
          fontSize: 12,
          height: 19 / 12,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          overflow: TextOverflow.ellipsis,
        ),
      );

  String _itemValueText(HighscoresEntry item) {
    final bool narrow = MediaQuery.of(context).size.width < 1280;
    final bool orange = (int.tryParse(item.onlineTime?.substring(0, 2) ?? '') ?? 0) >= 6;
    final bool red = (int.tryParse(item.onlineTime?.substring(0, 2) ?? '') ?? 0) >= 9;
    if (narrow && red) return '<red>${item.onlineTime ?? ''}<red>';
    if (narrow && orange) return '<orange>${item.onlineTime ?? ''}<orange>';
    if (narrow) return item.onlineTime ?? '';
    if (red) return '${item.world ?? ''} <red>${item.onlineTime ?? ''}<red>';
    if (orange) return '${item.world ?? ''} <orange>${item.onlineTime ?? ''}<orange>';
    return '${item.world ?? ''} <white>${item.onlineTime ?? ''}<white>';
  }
}
