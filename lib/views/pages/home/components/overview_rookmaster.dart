import 'package:flutter/material.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../../../controllers/home_controller.dart';
import '../../../../theme/colors.dart';
import '../../../../utils/src/routes.dart';
import '../../../widgets/src/other/better_text.dart';
import '../../../widgets/src/other/blinking_circle.dart';
import '../../../widgets/src/other/clickable_container.dart';
import '../../../widgets/src/other/shimmer_loading.dart';

class OverviewRookmaster extends StatefulWidget {
  @override
  State<OverviewRookmaster> createState() => _OverviewRookmasterState();
}

class _OverviewRookmasterState extends State<OverviewRookmaster> {
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
          'Rook Master',
          style: TextStyle(
            fontSize: 14,
            height: 22 / 14,
          ),
        ),
      );

  Widget _body() => Obx(
        () => ShimmerLoading(
          isLoading: homeCtrl.overviewRookmaster.isEmpty && homeCtrl.isLoading.value,
          child: ClickableContainer(
            enabled: _isEnabled,
            height: 143,
            onTap: homeCtrl.overviewRookmaster.isEmpty
                ? homeCtrl.getOverview
                : () => Get.toNamed<dynamic>('${Routes.highscores.name}/rookmaster'),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            color: AppColors.bgPaper,
            hoverColor: AppColors.bgHover,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Builder(
              builder: (_) {
                if (homeCtrl.overviewRookmaster.isEmpty && homeCtrl.isLoading.value) return _loading();
                if (homeCtrl.overviewRookmaster.isEmpty) return _reloadButton();
                if (homeCtrl.overviewRookmaster.isNotEmpty) return _listBuilder();
                return Container();
              },
            ),
          ),
        ),
      );

  bool get _isEnabled {
    if (homeCtrl.isLoading.value && homeCtrl.overviewRookmaster.isEmpty) return false;
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
          if (homeCtrl.overviewRookmaster.isNotEmpty) _item(homeCtrl.overviewRookmaster[0]),
          if (homeCtrl.overviewRookmaster.length >= 2) _item(homeCtrl.overviewRookmaster[1]),
          if (homeCtrl.overviewRookmaster.length >= 3) _item(homeCtrl.overviewRookmaster[2]),
          if (homeCtrl.overviewRookmaster.length >= 4) _item(homeCtrl.overviewRookmaster[3]),
          if (homeCtrl.overviewRookmaster.length >= 5) _item(homeCtrl.overviewRookmaster[4]),
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
    if (MediaQuery.of(context).size.width < 1280) return '<blue>${item.stringValue ?? ''}<blue>';
    return '${item.world ?? ''} <blue>${item.stringValue ?? ''}<blue>';
  }
}
