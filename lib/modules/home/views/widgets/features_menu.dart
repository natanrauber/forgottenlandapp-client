import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:get/get.dart';

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

class FeaturesMenu extends StatefulWidget {
  @override
  State<FeaturesMenu> createState() => _FeaturesMenuState();
}

class _FeaturesMenuState extends State<FeaturesMenu> {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();

  final SettingsController settingsCtrl = Get.find<SettingsController>();

  final List<GridButtonModel> _highscoresButtons = <GridButtonModel>[];
  final List<GridButtonModel> _libraryButtons = <GridButtonModel>[];
  final List<GridButtonModel> _otherButtons = <GridButtonModel>[];
  List<GridButtonModel> get _allButtons => _highscoresButtons + _otherButtons + _libraryButtons;

  final double crossAxisSpacing = 12;

  @override
  void initState() {
    super.initState();
    _highscoresButtons.clear();
    _highscoresButtons.add(_home());
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

  GridButtonModel _home() => GridButtonModel(
        enabled: true,
        name: 'Home',
        icon: CupertinoIcons.home,
        // resizeBy: -4,
        onTap: () => Get.toNamed<dynamic>(Routes.home.name),
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
