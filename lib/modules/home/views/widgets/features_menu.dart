import 'package:flutter/cupertino.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:get/get.dart';

import '../../../highscores/highscores.dart';
import '../../../settings/controllers/settings_controller.dart';
import 'feature_buttons.dart';
import 'grid_button_model.dart';

class FeaturesMenu extends StatefulWidget {
  @override
  State<FeaturesMenu> createState() => _FeaturesMenuState();
}

class _FeaturesMenuState extends State<FeaturesMenu> {
  late final FeatureButtons _featureButtons = FeatureButtons(
    highscoresCtrl: Get.find<HighscoresController>(),
    settingsCtrl: Get.find<SettingsController>(),
  );

  List<GridButtonModel> get _allButtons => <GridButtonModel>[
        _featureButtons.home,
        ..._featureButtons.highscores,
        ..._featureButtons.other,
        ..._featureButtons.library,
      ];

  @override
  Widget build(BuildContext context) => Container(
        height: (_allButtons.length * 55) - 10 + 24,
        width: 225,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgDefault,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _allButtons.length,
          itemBuilder: _itemBuilder,
        ),
      );

  Widget _itemBuilder(_, int index) {
    GridButtonModel item = _allButtons[index];

    return Column(
      children: <Widget>[
        if (index != 0) SizedBox(height: 10, width: 10),
        ClickableContainer(
          height: 45,
          enabled: item.enabled,
          onTap: item.onTap,
          color: AppColors.bgPaper,
          hoverColor: AppColors.bgHover,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: <Widget>[
              Icon(
                item.icon,
                size: 26 + item.resizeBy,
                color: item.enabled ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  item.shortName ?? item.name,
                  style: TextStyle(
                    height: 1,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
