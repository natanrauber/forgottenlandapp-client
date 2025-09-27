import 'package:flutter/material.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../../../controllers/highscores_controller.dart';
import '../../../../controllers/home_controller.dart';
import '../../../../theme/colors.dart';
import '../../../../utils/src/routes.dart';
import '../../../widgets/src/other/better_text.dart';
import '../../../widgets/src/other/blinking_circle.dart';
import '../../../widgets/src/other/clickable_container.dart';
import '../../../widgets/src/other/shimmer_loading.dart';

class OverviewExpgain extends StatefulWidget {
  @override
  State<OverviewExpgain> createState() => _OverviewExpgainState();
}

class _OverviewExpgainState extends State<OverviewExpgain> {
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
          'Exp gained',
          style: TextStyle(
            fontSize: 14,
            height: 22 / 14,
          ),
        ),
      );

  Widget _body() => Obx(
        () => ShimmerLoading(
          isLoading: homeCtrl.overviewExpgain.isEmpty && homeCtrl.isLoading.value,
          child: ClickableContainer(
            enabled: _isEnabled,
            height: 143,
            onTap: homeCtrl.overviewExpgain.isEmpty
                ? homeCtrl.getOverview
                : () async {
                    final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
                    return Get.toNamed('${Routes.highscores.name}/experiencegained/$timeframe');
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
                if (homeCtrl.overviewExpgain.isEmpty && homeCtrl.isLoading.value) return _loading();
                if (homeCtrl.overviewExpgain.isEmpty) return _emptyBuilder();
                if (homeCtrl.overviewExpgain.isNotEmpty) return _listBuilder();
                return Container();
              },
            ),
          ),
        ),
      );

  bool get _isEnabled {
    if (homeCtrl.isLoading.value && homeCtrl.overviewExpgain.isEmpty) return false;
    return true;
  }

  Widget _emptyBuilder() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/creatures/skeleton.gif'),
          const SizedBox(width: 10),
          const Text(
            'Waiting for data...',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
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
          if (homeCtrl.overviewExpgain.isNotEmpty) _item(homeCtrl.overviewExpgain[0]),
          if (homeCtrl.overviewExpgain.length >= 2) _item(homeCtrl.overviewExpgain[1]),
          if (homeCtrl.overviewExpgain.length >= 3) _item(homeCtrl.overviewExpgain[2]),
          if (homeCtrl.overviewExpgain.length >= 4) _item(homeCtrl.overviewExpgain[3]),
          if (homeCtrl.overviewExpgain.length >= 5) _item(homeCtrl.overviewExpgain[4]),
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
    if (MediaQuery.of(context).size.width < 1280) return '<green>+${item.stringValue ?? ''}<green>';
    return '${item.world ?? ''} <green>+${item.stringValue ?? ''}<green>';
  }
}
