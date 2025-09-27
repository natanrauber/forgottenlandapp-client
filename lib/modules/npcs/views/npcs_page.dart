import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../../theme/colors.dart';
import '../../../theme/theme.dart';
import '../../../views/widgets/src/fields/custom_text_field.widget.dart';
import '../../../views/widgets/src/other/app_page.dart';
import '../../../views/widgets/src/other/error_builder.dart';
import '../controllers/npcs_controller.dart';
import 'components/npc_widget.dart';

class NpcsPage extends StatefulWidget {
  @override
  State<NpcsPage> createState() => _NpcsPageState();
}

class _NpcsPageState extends State<NpcsPage> {
  NpcsController npcsCtrl = Get.find<NpcsController>();

  Timer searchTimer = Timer(Duration.zero, () {});

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'npcs',
        postFrameCallback: npcsCtrl.getAll,
        onRefresh: npcsCtrl.getAll,
        body: Column(
          children: <Widget>[
            _title(),
            _divider(),
            _searchBar(),
            const SizedBox(height: 10),
            _body(),
          ],
        ),
      );

  Widget _title() => SelectableText(
        'Rookgaard NPCs transcripts',
        style: appTheme().textTheme.titleMedium,
      );

  Widget _divider() => Container(
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        child: const Divider(height: 1),
      );

  Widget _searchBar() => CustomTextField(
        loading: npcsCtrl.isLoading.isTrue,
        label: 'Search',
        controller: npcsCtrl.searchController,
        onChanged: (_) {
          if (searchTimer.isActive) searchTimer.cancel();

          searchTimer = Timer(
            const Duration(milliseconds: 250),
            () => npcsCtrl.filterList(),
          );
        },
      );

  Widget _body() => Obx(
        () {
          if (npcsCtrl.isLoading.value) return _loading();
          if (npcsCtrl.response.error) {
            return ErrorBuilder(
              'Internal server error',
              reloadButtonText: 'Try again',
              onTapReload: npcsCtrl.getAll,
            );
          }
          return _listBuilder();
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
        itemCount: npcsCtrl.npcs.length,
        itemBuilder: _itemBuilder,
      );

  Widget _itemBuilder(BuildContext context, int index) {
    final NPC npc = npcsCtrl.npcs[index];

    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
      child: NpcWidget(npc),
    );
  }
}
