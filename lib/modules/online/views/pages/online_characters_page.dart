import 'package:flutter/material.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../../character/controllers/character_controller.dart';
import '../../controllers/online_controller.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import '../../../shared/views/widgets/other/app_page.dart';
import '../widgets/online_entry_widget.dart';
import '../widgets/online_filters_widget.dart';

class OnlineCharactersPage extends StatefulWidget {
  @override
  State<OnlineCharactersPage> createState() => _OnlineCharactersPageState();
}

class _OnlineCharactersPageState extends State<OnlineCharactersPage> {
  final CharacterController characterCtrl = Get.find<CharacterController>();
  final OnlineController onlineCtrl = Get.find<OnlineController>();

  Future<void> _loadOnlineData() async {
    await onlineCtrl.getOnlineCharacters();
    onlineCtrl.runTimer();
  }

  @override
  void dispose() {
    super.dispose();
    onlineCtrl.cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.of(context).size.width >= 800;

    return AppPage(
      screenName: 'online',
      postFrameCallback: _loadOnlineData,
      onRefresh: _loadOnlineData,
      padding: wide ? const EdgeInsets.fromLTRB(16, 16, 16, 60) : EdgeInsets.zero,
      topWidget: wide ? OnlineFilters() : null,
      body: Column(
        children: <Widget>[
          //
          if (!wide) OnlineFilters(),
          if (!wide) const SizedBox(height: 16),

          Padding(
            padding: wide ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 16),
            child: _body(),
          ),
        ],
      ),
    );
  }

  Widget _body() => Obx(
        () {
          if (onlineCtrl.isLoading.value) return _loading();
          if (onlineCtrl.filteredList.isNotEmpty) return _listBuilder();
          if (!onlineCtrl.isLoading.value) return _reloadButton();
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
        itemCount: onlineCtrl.filteredList.length,
        itemBuilder: _itemBuilder,
      );

  Widget _itemBuilder(BuildContext context, int index) {
    final HighscoresEntry item = onlineCtrl.filteredList[index];

    return OnlineEntryWidget(
      index: index,
      item: item,
      characterCtrl: characterCtrl,
      onlineCtrl: onlineCtrl,
    );
  }

  Widget _reloadButton() => GestureDetector(
        onTap: onlineCtrl.getOnlineCharacters,
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
}
