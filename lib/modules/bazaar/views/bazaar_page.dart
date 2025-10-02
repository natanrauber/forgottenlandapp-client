import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../shared/views/widgets/other/app_page.dart';
import '../controllers/bazaar_controller.dart';
import 'components/auction_widget.dart';
import 'components/bazaar_filter_widget.dart';

class BazaarPage extends StatefulWidget {
  @override
  State<BazaarPage> createState() => _BazaarPageState();
}

class _BazaarPageState extends State<BazaarPage> {
  final BazaarController bazaarCtrl = Get.find<BazaarController>();

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'bazaar',
        postFrameCallback: bazaarCtrl.getAuctions,
        onRefresh: bazaarCtrl.getAuctions,
        padding: const EdgeInsets.symmetric(vertical: 20),
        body: Column(
          children: <Widget>[
            BazaarFilters(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _body(),
            ),
          ],
        ),
      );

  Widget _body() => Obx(
        () {
          if (bazaarCtrl.isLoading.value) return _loading();
          if (bazaarCtrl.filteredList.isNotEmpty) return _listBuilder();
          if (!bazaarCtrl.isLoading.value) return _reloadButton();
          return Container();
        },
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

  Widget _listBuilder() => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: bazaarCtrl.filteredList.length,
        itemBuilder: _itemBuilder,
      );

  Widget _itemBuilder(BuildContext context, int index) {
    final Auction entry = bazaarCtrl.filteredList[index];

    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
      child: AuctionWidget(entry),
    );
  }

  Widget _reloadButton() => GestureDetector(
        onTap: bazaarCtrl.getAuctions,
        child: Container(
          height: 110,
          width: 110,
          padding: const EdgeInsets.all(30),
          child: const Icon(
            Icons.refresh,
            size: 50,
            color: AppColors.bgPaper,
          ),
        ),
      );
}
