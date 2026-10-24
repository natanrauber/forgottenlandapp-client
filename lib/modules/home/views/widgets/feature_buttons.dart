import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../core/routes.dart';
import '../../../highscores/highscores.dart';
import '../../../settings/controllers/settings_controller.dart';
import '../../../settings/models/feature_model.dart';
import 'grid_button_model.dart';

class FeatureButtons {
  FeatureButtons({
    required this.highscoresCtrl,
    required this.settingsCtrl,
  });

  final HighscoresController highscoresCtrl;
  final SettingsController settingsCtrl;

  bool _isEnabled(String name) =>
      settingsCtrl.features.firstWhereOrNull((Feature e) => e.name == name)?.enabled ?? false;

  GridButtonModel get home => GridButtonModel(
        enabled: true,
        name: 'Home',
        icon: CupertinoIcons.home,
        onTap: () => Get.toNamed<dynamic>(Routes.home.name),
      );

  List<GridButtonModel> get highscores => <GridButtonModel>[
        _highscores(),
        _rookmaster(),
        _expgained(),
        _onlineTime(),
      ];

  List<GridButtonModel> get other => <GridButtonModel>[
        _onlineCharacters(),
        _characters(),
        _bazaar(),
        _liveStreams(),
      ];

  List<GridButtonModel> get library => <GridButtonModel>[
        _books(),
        _npcs(),
        _about(),
      ];

  GridButtonModel _highscores() => GridButtonModel(
        enabled: _isEnabled('Highscores'),
        name: 'Highscores',
        icon: CupertinoIcons.chart_bar_alt_fill,
        resizeBy: 2,
        onTap: _goToHighscoresPage,
      );

  Future<void> _goToHighscoresPage() async {
    final String c = highscoresCtrl.category.value;
    final String p = highscoresCtrl.timeframe.value;
    String route = '${Routes.highscores.name}/$c';
    if (c == 'Experience gained' || c == 'Online time') route = '$route/$p';

    return Get.toNamed(route.toLowerCase().replaceAll(' ', ''));
  }

  GridButtonModel _expgained() => GridButtonModel(
        enabled: _isEnabled('Highscores'),
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
        enabled: _isEnabled('Highscores'),
        name: 'Rook\nMaster',
        shortName: 'Rook Master',
        icon: FontAwesomeIcons.trophy,
        resizeBy: -4,
        onTap: () => Get.toNamed<dynamic>('${Routes.highscores.name}/rookmaster'),
      );

  GridButtonModel _onlineTime() => GridButtonModel(
        enabled: _isEnabled('Highscores'),
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
        enabled: _isEnabled('Online'),
        name: 'Who is\nonline',
        shortName: 'Online',
        icon: CupertinoIcons.check_mark_circled_solid,
        onTap: () => Get.toNamed<dynamic>(Routes.online.name),
      );

  GridButtonModel _characters() => GridButtonModel(
        enabled: _isEnabled('Characters'),
        name: 'Characters',
        icon: CupertinoIcons.person_fill,
        onTap: () => Get.toNamed<dynamic>(Routes.character.name),
      );

  GridButtonModel _bazaar() => GridButtonModel(
        enabled: _isEnabled('Bazaar'),
        name: 'Char\nBazaar',
        shortName: 'Bazaar',
        icon: CupertinoIcons.money_dollar_circle_fill,
        onTap: () => Get.toNamed<dynamic>(Routes.bazaar.name),
      );

  GridButtonModel _liveStreams() => GridButtonModel(
        enabled: _isEnabled('Streams'),
        name: 'Live\nstreams',
        shortName: 'Streaming',
        icon: CupertinoIcons.dot_radiowaves_left_right,
        onTap: () => Get.toNamed<dynamic>(Routes.livestreams.name),
      );

  GridButtonModel _books() => GridButtonModel(
        enabled: _isEnabled('Books'),
        name: 'Books',
        icon: FontAwesomeIcons.book,
        resizeBy: -2,
        onTap: () => Get.toNamed<dynamic>(Routes.books.name),
      );

  GridButtonModel _npcs() => GridButtonModel(
        enabled: _isEnabled('NPCs'),
        name: 'NPCs\ntranscripts',
        shortName: 'Transcripts',
        icon: CupertinoIcons.doc_text_fill,
        onTap: () => Get.toNamed<dynamic>(Routes.npcs.name),
      );

  GridButtonModel _about() => GridButtonModel(
        enabled: _isEnabled('About'),
        name: 'About\nFL',
        shortName: 'About FL',
        icon: CupertinoIcons.shield_lefthalf_fill,
        onTap: () => Get.toNamed<dynamic>(Routes.guild.name),
      );
}
