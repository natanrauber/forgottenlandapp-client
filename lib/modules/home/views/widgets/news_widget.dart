import 'package:flutter/material.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../controllers/home_controller.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';

class NewsWidget extends StatefulWidget {
  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
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
          'Latest news',
          style: TextStyle(
            fontSize: 14,
            height: 22 / 14,
          ),
        ),
      );

  Widget _body() => Obx(
        () => ShimmerLoading(
          isLoading: homeCtrl.news.isEmpty && homeCtrl.isLoading.value,
          child: ClickableContainer(
            enabled: homeCtrl.news.isEmpty,
            onTap: homeCtrl.getNews,
            height: MediaQuery.of(context).size.width >= 600 ? 511 : null,
            padding: const EdgeInsets.all(12),
            color: AppColors.bgPaper,
            hoverColor: AppColors.bgHover,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Builder(
              builder: (_) {
                if (homeCtrl.news.isEmpty && homeCtrl.isLoading.value) return _loading();
                if (homeCtrl.news.isEmpty) return _reloadButton();
                if (homeCtrl.news.isNotEmpty) return _listBuilder();
                return Container();
              },
            ),
          ),
        ),
      );

  Widget _reloadButton() => Center(
        child: Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(30),
          child: Icon(
            Icons.refresh,
            size: 40,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
        ),
      );

  Widget _loading() => Center(
        child: Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(37.5),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ),
      );

  Widget _listBuilder() => Flex(
        direction: MediaQuery.of(context).size.width >= 600 ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (homeCtrl.news.isNotEmpty) _item(homeCtrl.news[0]),
          if (homeCtrl.news.length >= 2) const SizedBox(height: 10, width: 10),
          if (homeCtrl.news.length >= 2) _item(homeCtrl.news[1]),

          //
          if (homeCtrl.news.length >= 3 && MediaQuery.of(context).size.width >= 600)
            const SizedBox(height: 10, width: 10),
          if (homeCtrl.news.length >= 3 && MediaQuery.of(context).size.width >= 600) _item(homeCtrl.news[2]),

          //
          if (homeCtrl.news.length >= 4 && MediaQuery.of(context).size.width >= 600)
            const SizedBox(height: 10, width: 10),
          if (homeCtrl.news.length >= 4 && MediaQuery.of(context).size.width >= 600) _item(homeCtrl.news[3]),

          //
          if (homeCtrl.news.length >= 5 && MediaQuery.of(context).size.width >= 600)
            const SizedBox(height: 10, width: 10),
          if (homeCtrl.news.length >= 5 && MediaQuery.of(context).size.width >= 600) _item(homeCtrl.news[4]),
        ],
      );

  Widget _item(News item) {
    if (MediaQuery.of(context).size.width >= 600) return _itemBody(item);
    return Expanded(child: _itemBody(item));
  }

  Widget _itemBody(News item) => ClickableContainer(
        onTap: () => _openSelectedNews(item),
        height: 89,
        padding: const EdgeInsets.all(12),
        alignment: Alignment.centerLeft,
        color: AppColors.bgDefault.withValues(alpha: 0.75),
        hoverColor: AppColors.bgHover,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: item.date == DT.tibia.today()
              ? Border.all(
                  color: AppColors.primary,
                  strokeAlign: BorderSide.strokeAlignOutside,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            Text(
              item.news ?? '',
              maxLines: 1,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              MediaQuery.of(context).size.width > 600 ? 'Date: ${item.date ?? ''}' : item.date ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              MediaQuery.of(context).size.width > 600
                  ? 'Category: ${item.category?.capitalizeString() ?? ''}'
                  : item.category?.capitalizeString() ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

  Future<void> _openSelectedNews(News item) async {
    final String? url = item.url;
    if (url == null) return;
    await launchUrlString(url);
  }
}
