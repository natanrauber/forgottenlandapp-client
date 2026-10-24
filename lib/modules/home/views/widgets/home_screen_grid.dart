import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:get/get.dart';

import '../../../highscores/highscores.dart';
import '../../../settings/controllers/settings_controller.dart';
import 'feature_buttons.dart';
import 'grid_button_model.dart';

class HomeScreenGrid extends StatefulWidget {
  @override
  State<HomeScreenGrid> createState() => _HomeScreenGridState();
}

class _HomeScreenGridState extends State<HomeScreenGrid> {
  late final FeatureButtons _featureButtons = FeatureButtons(
    highscoresCtrl: Get.find<HighscoresController>(),
    settingsCtrl: Get.find<SettingsController>(),
  );

  List<GridButtonModel> get _highscoresButtons => _featureButtons.highscores;
  List<GridButtonModel> get _libraryButtons => _featureButtons.library;
  List<GridButtonModel> get _otherButtons => _featureButtons.other;

  final double crossAxisSpacing = 12;

  @override
  Widget build(BuildContext context) => Builder(
        builder: (_) {
          if (MediaQuery.of(context).size.width >= 1000) return _gridWide();
          if (MediaQuery.of(context).size.width >= 856) return _gridMedium();
          return _gridNarrow();
        },
      );

  Widget _gridWide() => _grid(
        list: _highscoresButtons + _otherButtons + _libraryButtons,
        asRow: true,
      );

  Widget _gridNarrow() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _grid(name: 'Highscores', list: _highscoresButtons),
          const SizedBox(height: 16),
          _grid(name: 'Other', list: _otherButtons),
          const SizedBox(height: 16),
          _grid(name: 'Library', list: _libraryButtons),
        ],
      );

  Widget _gridMedium() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _grid(name: 'Highscores', list: _highscoresButtons),
              const SizedBox(
                width: 16,
              ),
              _grid(name: 'Other', list: _otherButtons),
            ],
          ),
          const SizedBox(height: 16),
          _grid(name: 'Library', list: _libraryButtons),
        ],
      );

  Widget _grid({String? name, required List<GridButtonModel> list, bool asRow = false}) {
    final int crossAxisCount = asRow ? list.length : 4;
    double screenWidth = MediaQuery.of(context).size.width;
    screenWidth = screenWidth > 436 && !asRow ? 436 : screenWidth;
    if (screenWidth > 1280) screenWidth = 1280;
    final double spacing = (crossAxisCount - 1) * crossAxisSpacing;
    final double buttonWidth = (screenWidth - spacing - 32 - 24) / crossAxisCount;
    final double buttonHeight = buttonWidth + (asRow ? 23 : 36);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (name != null) _title(name),
        if (name != null) const SizedBox(height: 3),
        Container(
          constraints: asRow ? null : const BoxConstraints(maxWidth: 404),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          decoration: BoxDecoration(
            color: asRow && MediaQuery.of(context).size.width >= 1280 ? AppColors.bgDefault : AppColors.bgPaper,
            borderRadius: BorderRadius.circular(8),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: buttonWidth / (buttonHeight < (asRow ? 109 : 122) ? buttonHeight : (asRow ? 109 : 122)),
            ),
            itemCount: list.length,
            itemBuilder: (_, int index) => _gridItemBuilder(list, index, crossAxisCount, asRow),
          ),
        ),
      ],
    );
  }

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.only(left: 3),
        child: SelectableText(text),
      );

  Widget _gridItemBuilder(List<GridButtonModel> list, int index, int crossAxisCount, bool asRow) {
    final GridButtonModel item = list[index];

    return Column(
      children: <Widget>[
        _buttonBody(item, crossAxisCount, asRow),
        SizedBox(height: !asRow && item.name.contains('\n') ? 4 : 8),
        _buttonName(item, asRow),
      ],
    );
  }

  Widget _buttonBody(GridButtonModel item, int crossAxisCount, bool asRow) {
    double screenWidth = MediaQuery.of(context).size.width;
    screenWidth = screenWidth > 436 && !asRow ? 436 : screenWidth;
    if (screenWidth > 1280) screenWidth = 1280;
    final double spacing = (crossAxisCount - 1) * crossAxisSpacing;
    final double buttonSize = (screenWidth - spacing - 32 - 24) / crossAxisCount;

    return ClickableContainer(
      enabled: item.enabled,
      onTap: item.onTap,
      height: buttonSize,
      width: buttonSize,
      constraints: const BoxConstraints(maxHeight: 86, maxWidth: 86),
      color: asRow && MediaQuery.of(context).size.width >= 1280
          ? AppColors.bgPaper
          : AppColors.bgDefault.withValues(alpha: 0.75),
      hoverColor: AppColors.bgHover,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        item.icon,
        size: 30 + item.resizeBy,
        color: item.enabled ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buttonName(GridButtonModel item, bool asRow) => Text(
        asRow ? item.shortName ?? item.name : item.name,
        textAlign: TextAlign.center,
        maxLines: !asRow && item.name.contains('\n') ? 2 : 1,
        style: TextStyle(
          fontSize: asRow ? 10 : 11,
          height: asRow ? 15 / 10 : 15 / 11,
          color: item.enabled ? AppColors.textPrimary : AppColors.textSecondary.withValues(alpha: 0.5),
          overflow: TextOverflow.ellipsis,
        ),
      );
}
