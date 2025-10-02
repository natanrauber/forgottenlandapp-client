import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:forgottenlandapp_designsystem/designsystem.dart';
import '../../../../core/routes.dart';

import '../../../highscores/highscores.dart';
import '../../../settings/controllers/settings_controller.dart';
import '../../../settings/models/feature_model.dart';

class GridButtonModel {
  GridButtonModel({
    required this.enabled,
    required this.name,
    required this.icon,
    this.shortName,
    this.onTap,
    this.resizeBy = 0,
  });

  final bool enabled;
  final String name;
  final String? shortName;
  final IconData icon;
  dynamic Function()? onTap;
  final double resizeBy;
}

class HomeScreenGrid extends StatefulWidget {
  @override
  State<HomeScreenGrid> createState() => _HomeScreenGridState();
}

class _HomeScreenGridState extends State<HomeScreenGrid> {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();

  final SettingsController settingsCtrl = Get.find<SettingsController>();

  final List<GridButtonModel> _highscoresButtons = <GridButtonModel>[];
  final List<GridButtonModel> _libraryButtons = <GridButtonModel>[];
  final List<GridButtonModel> _otherButtons = <GridButtonModel>[];

  final double crossAxisSpacing = 12;

  @override
  void initState() {
    super.initState();
    _highscoresButtons.clear();
    _highscoresButtons.add(_highscores());
    _highscoresButtons.add(_rookmaster());
    _highscoresButtons.add(_expgained());
    _highscoresButtons.add(_onlineTime());

    _otherButtons.add(_onlineCharacters());
    _otherButtons.add(_characters());
    _otherButtons.add(_bazaar());
    _otherButtons.add(_liveStreams());

    _libraryButtons.clear();
    _libraryButtons.add(_books());
    _libraryButtons.add(_npcs());
    _libraryButtons.add(_about());
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: (_) {
          if (MediaQuery.of(context).size.width >= 1000) return _gridWide();
          if (MediaQuery.of(context).size.width >= 856) return _gridMedium();
          return _gridNarrow();
        },
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

  Widget _gridWide() => _grid(
        list: _highscoresButtons + _otherButtons + _libraryButtons,
        asRow: true,
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
          // fontWeight: FontWeight.w500,
          color: item.enabled ? AppColors.textPrimary : AppColors.textSecondary.withValues(alpha: 0.5),
          overflow: TextOverflow.ellipsis,
        ),
      );

  GridButtonModel _highscores() => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Highscores')?.enabled ?? false,
        name: 'Highscores',
        icon: CupertinoIcons.chart_bar_alt_fill,
        resizeBy: 2,
        onTap: _getToHighscoresPage,
      );

  Future<void> _getToHighscoresPage() async {
    final String c = highscoresCtrl.category.value;
    final String p = highscoresCtrl.timeframe.value;
    String route = '${Routes.highscores.name}/$c';
    if (c == 'Experience gained' || c == 'Online time') route = '$route/$p';

    return Get.toNamed(route.toLowerCase().replaceAll(' ', ''));
  }

  GridButtonModel _expgained() => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Highscores')?.enabled ?? false,
        name: 'Exp\ngained',
        shortName: 'Exp gained',
        icon: FontAwesomeIcons.chartLine,
        resizeBy: -4,
        onTap: () {
          final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
          return Get.toNamed<dynamic>('${Routes.highscores.name}/experiencegained/$timeframe');
        },
      );

  GridButtonModel _rookmaster() => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Highscores')?.enabled ?? false,
        name: 'Rook\nMaster',
        shortName: 'Rook Master',
        icon: FontAwesomeIcons.trophy,
        resizeBy: -4,
        onTap: () => Get.toNamed<dynamic>('${Routes.highscores.name}/rookmaster'),
      );

  GridButtonModel _onlineTime() => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Highscores')?.enabled ?? false,
        name: 'Online\ntime',
        shortName: 'Online time',
        icon: FontAwesomeIcons.solidClock,
        resizeBy: -4,
        onTap: () {
          final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
          return Get.toNamed<dynamic>('${Routes.highscores.name}/onlinetime/$timeframe');
        },
      );

  GridButtonModel _onlineCharacters() => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Online')?.enabled ?? false,
        name: 'Who is\nonline',
        shortName: 'Online',
        icon: CupertinoIcons.check_mark_circled_solid,
        onTap: () => Get.toNamed<dynamic>(Routes.online.name),
      );

  GridButtonModel _characters() => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Characters')?.enabled ?? false,
        name: 'Characters',
        icon: CupertinoIcons.person_fill,
        onTap: () => Get.toNamed<dynamic>(Routes.character.name),
      );

  GridButtonModel _bazaar() => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Bazaar')?.enabled ?? false,
        name: 'Char\nBazaar',
        shortName: 'Bazaar',
        icon: CupertinoIcons.money_dollar_circle_fill,
        onTap: () => Get.toNamed<dynamic>(Routes.bazaar.name),
      );

  GridButtonModel _liveStreams() => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Streams')?.enabled ?? false,
        name: 'Live\nstreams',
        shortName: 'Streaming',
        icon: CupertinoIcons.dot_radiowaves_left_right,
        onTap: () => Get.toNamed<dynamic>(Routes.livestreams.name),
      );

  GridButtonModel _books() => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'Books')?.enabled ?? false,
        name: 'Books',
        icon: FontAwesomeIcons.book,
        resizeBy: -2,
        onTap: () => Get.toNamed<dynamic>(Routes.books.name),
      );

  GridButtonModel _npcs() => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'NPCs')?.enabled ?? false,
        name: 'NPCs\ntranscripts',
        shortName: 'Transcripts',
        icon: CupertinoIcons.doc_text_fill,
        onTap: () => Get.toNamed<dynamic>(Routes.npcs.name),
      );

  GridButtonModel _about() => GridButtonModel(
        enabled: settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == 'About')?.enabled ?? false,
        name: 'About\nFL',
        shortName: 'About FL',
        icon: CupertinoIcons.shield_lefthalf_fill,
        onTap: () => Get.toNamed<dynamic>(Routes.guild.name),
      );
}
