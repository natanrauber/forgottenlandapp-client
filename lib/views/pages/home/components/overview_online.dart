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

class OverviewOnline extends StatefulWidget {
  @override
  State<OverviewOnline> createState() => _OverviewOnlineState();
}

class _OverviewOnlineState extends State<OverviewOnline> {
  final HomeController homeCtrl = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title(),
            const SizedBox(height: 3),
            _body(),
          ],
        ),
      );

  Widget _title() => Container(
        height: 22,
        padding: const EdgeInsets.only(left: 3),
        child: const SelectableText(
          'Online now',
          style: TextStyle(
            fontSize: 14,
            height: 22 / 14,
          ),
        ),
      );

  Widget _body() => ShimmerLoading(
        isLoading: homeCtrl.overviewOnline.isEmpty && homeCtrl.isLoading.value,
        child: ClickableContainer(
          height: 695,
          enabled: !homeCtrl.isLoading.value && homeCtrl.overviewOnline.isEmpty,
          onTap: homeCtrl.getOverview,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(12),
          color: AppColors.bgPaper,
          hoverColor: AppColors.bgHover,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Builder(
            builder: (_) {
              if (homeCtrl.overviewOnline.isEmpty && homeCtrl.isLoading.value) return _loading();
              if (homeCtrl.overviewOnline.isEmpty) return _reloadButton();
              if (homeCtrl.overviewOnline.isNotEmpty) return _listBuilder();
              return Container();
            },
          ),
        ),
      );

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
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homeCtrl.overviewOnline.length > 25 ? 25 : homeCtrl.overviewOnline.length,
            itemBuilder: (_, int index) => _item(homeCtrl.overviewOnline[index]),
          ),
          Expanded(child: Container()),
          _buttonSeeAll(),
        ],
      );

  Widget _item(HighscoresEntry item) => Container(
        height: 19,
        margin: const EdgeInsets.only(bottom: 6),
        child: Row(
          children: <Widget>[
            if (homeCtrl.isLoading.value) const SizedBox(width: 10) else _onlineIndicator(),
            const SizedBox(width: 9),
            _itemName(item),
            const SizedBox(width: 10),
            _itemValue(item),
          ],
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
        '${item.world?.name ?? ''} <blue>${item.level?.toString() ?? ''}<blue>',
        selectable: false,
        style: TextStyle(
          fontSize: 12,
          height: 19 / 12,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _buttonSeeAll() => ClickableContainer(
        onTap: () => Get.toNamed<dynamic>(Routes.online.name),
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: AppColors.bgDefault,
        hoverColor: AppColors.bgHover,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'See all',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.primary,
          ),
        ),
      );
}
