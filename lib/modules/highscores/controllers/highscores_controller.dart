import 'package:flutter/material.dart';
import 'package:forgottenlandapp_adapters/adapters.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get.dart';

import '../../../core/controller.dart';
import '../../../main.dart';
import '../../online/controllers/online_controller.dart';
import '../../shared/controllers/worlds_controller.dart';

class HighscoresController extends Controller {
  HighscoresController(this.databaseClient, this.httpClient);

  final IDatabaseClient databaseClient;
  final IHttpClient httpClient;

  final OnlineController _onlineCtrl = Get.find<OnlineController>();
  final WorldsController _worldsCtrl = Get.find<WorldsController>();

  String? rankLastUpdate;

  DateTime _loadStartTime = DateTime.now();

  RxInt pageCtrl = 1.obs;

  RxList<Supporter> supporters = <Supporter>[].obs;
  RxList<String> hidden = <String>[].obs;
  RxList<HighscoresEntry> rawList = <HighscoresEntry>[].obs;
  TextController searchController = TextController();
  RxList<HighscoresEntry> filteredList = <HighscoresEntry>[].obs;
  RxString category = LIST.category.first.obs;
  RxString timeframe = LIST.timeframe.first.obs;
  Rx<World> world = World(name: 'All').obs;
  RxString battleyeType = LIST.battleyeType.first.obs;
  RxString location = LIST.location.first.obs;
  RxString pvpType = LIST.pvpType.first.obs;
  RxString worldType = LIST.worldType.first.obs;
  RxBool enableBattleyeType = true.obs;
  RxBool enableLocation = true.obs;
  RxBool enablePvpType = true.obs;
  RxBool enableWorldType = true.obs;
  RxBool loadedAll = false.obs;
  Map<String, AssetImage> images = <String, AssetImage>{
    'assets/icons/battleye_type/green.png': const AssetImage('assets/icons/battleye_type/green.png'),
    'assets/icons/battleye_type/yellow.png': const AssetImage('assets/icons/battleye_type/yellow.png'),
    'assets/icons/battleye_type/none.png': const AssetImage('assets/icons/battleye_type/none.png'),
    'assets/icons/pvp_type/hardcore_pvp.png': const AssetImage('assets/icons/pvp_type/hardcore_pvp.png'),
    'assets/icons/pvp_type/open_pvp.png': const AssetImage('assets/icons/pvp_type/open_pvp.png'),
    'assets/icons/pvp_type/optional_pvp.png': const AssetImage('assets/icons/pvp_type/optional_pvp.png'),
    'assets/icons/pvp_type/retro_hardcore_pvp.png': const AssetImage('assets/icons/pvp_type/retro_hardcore_pvp.png'),
    'assets/icons/pvp_type/retro_open_pvp.png': const AssetImage('assets/icons/pvp_type/retro_open_pvp.png'),
    'assets/icons/rank/globalrank1.png': const AssetImage('assets/icons/rank/globalrank1.png'),
    'assets/icons/rank/globalrank2.png': const AssetImage('assets/icons/rank/globalrank2.png'),
    'assets/icons/rank/globalrank3.png': const AssetImage('assets/icons/rank/globalrank3.png'),
    'assets/icons/rank/globalrank4.png': const AssetImage('assets/icons/rank/globalrank4.png'),
    'assets/icons/rank/rank1.png': const AssetImage('assets/icons/rank/rank1.png'),
    'assets/icons/rank/rank2.png': const AssetImage('assets/icons/rank/rank2.png'),
    'assets/icons/rank/rank3.png': const AssetImage('assets/icons/rank/rank3.png'),
    'assets/icons/rank/rank4.png': const AssetImage('assets/icons/rank/rank4.png'),
  };

  bool get _shouldLoadMore {
    if (loadedAll.value) return false;
    if (DateTime.now().difference(_loadStartTime).inSeconds > 5) return false;
    if (searchController.text.isNotEmpty) return filteredList.isEmpty;
    return rawList.length < 1000 && filteredList.length < 10;
  }

  Future<void> loadHighscores({bool newPage = false, bool resetTimer = true}) async {
    MyHttpResponse response;

    pageCtrl.value = newPage ? pageCtrl.value + 1 : 1;
    if (!newPage) loadedAll = false.obs;
    if (pageCtrl.value > 20) return;
    if (pageCtrl.value == 1) rankLastUpdate = null;
    if (pageCtrl.value == 1) rawList.clear();
    if (pageCtrl.value == 1) filteredList.clear();
    if (resetTimer) _loadStartTime = DateTime.now();
    if (DateTime.now().difference(_loadStartTime).inSeconds > 5) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    if (_worldsCtrl.list.isEmpty) await _worldsCtrl.getWorlds();

    try {
      String cat = category.value;
      if (cat == 'Experience gained') cat = '$cat+$timeframe';
      if (cat == 'Online time') cat = '$cat+$timeframe';

      response = await httpClient.get(
        '${env[EnvVar.pathForgottenLandApi]}/highscores/$world/$cat/$pageCtrl'.toLowerCase().replaceAll(' ', ''),
      );

      if (response.statusCode == 204 || response.statusCode == 404) {
        loadedAll.value = true;
      } else if (response.success && response.dataAsMap['data'] == null) {
        loadedAll.value = true;
      } else if (response.success) {
        final Record aux = Record.fromJson(
          (response.dataAsMap['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
        );
        if (pageCtrl.value == 1) rankLastUpdate = response.dataAsMap['data']['timestamp'] as String?;
        _onlineCtrl.onlineTimes = <HighscoresEntry>[].obs;

        _populateList(aux.list);
      } else {
        pageCtrl = pageCtrl--;
        return loadHighscores(newPage: newPage, resetTimer: false);
      }
    } catch (e) {
      customPrint(e, color: PrintColor.red);
    }

    return filterList(resetTimer: false);
  }

  void _populateList(List<HighscoresEntry> responseList) {
    for (final HighscoresEntry entry in responseList) {
      entry.world = _worldsCtrl.list.firstWhere(
        (World e) => e.name?.toLowerCase() == entry.world?.name?.toLowerCase(),
        orElse: () => World(name: entry.world?.name),
      );

      entry.supporterTitle =
          supporters.firstWhere((Supporter e) => e.name == entry.name, orElse: () => Supporter()).title;

      entry.onlineTime ??= _onlineCtrl.onlineTimes
          .firstWhere((HighscoresEntry e) => e.name == entry.name, orElse: () => HighscoresEntry())
          .onlineTime;

      rawList.add(entry);

      if (category.value == 'Achievements' && (entry.value ?? 0) > 38) rawList.remove(entry);
    }
  }

  Future<void> filterList({bool resetTimer = true}) async {
    isLoading.value = true;

    filteredList.clear();

    if (resetTimer) _loadStartTime = DateTime.now();

    for (final HighscoresEntry item in rawList) {
      bool valid = true;

      if (hidden.contains(item.name)) valid = false;

      if (battleyeType.value != 'All') {
        if (battleyeType.value != item.world?.battleyeType) valid = false;
      }

      if (location.value != 'All') {
        if (item.world?.location != location.value) valid = false;
      }

      if (pvpType.value != 'All') {
        if (item.world?.pvpType?.toLowerCase() != pvpType.toLowerCase()) valid = false;
      }

      if (worldType.value != 'All') {
        if (item.world?.worldType?.toLowerCase() != worldType.toLowerCase()) valid = false;
      }

      if (searchController.text.isNotEmpty) {
        if (item.name?.toLowerCase().contains(searchController.text.toLowerCase()) != true) valid = false;
      }

      if (valid) filteredList.add(item);
    }

    if (_shouldLoadMore) {
      return loadHighscores(newPage: true, resetTimer: false);
    } else {
      isLoading.value = false;
    }
  }

  Future<void> getSupporters() async {
    if (supporters.isNotEmpty) return;
    isLoading.value = true;

    try {
      final dynamic response = await databaseClient.from('supporter').select();
      for (final dynamic e in response as List<dynamic>) {
        if (e is Map<String, dynamic>) supporters.add(Supporter.fromJson(e));
      }
    } catch (e) {
      customPrint(e, color: PrintColor.red);
    }

    isLoading.value = false;
  }

  Future<void> getHidden() async {
    if (hidden.isNotEmpty) return;
    isLoading.value = true;

    try {
      final dynamic response = await databaseClient.from('hidden').select();
      for (final dynamic e in response as List<dynamic>) {
        if (e is Map<String, dynamic> && e['name'] is String) hidden.add(e['name'] as String);
      }
    } catch (e) {
      customPrint(e, color: PrintColor.red);
    }

    isLoading.value = false;
  }

  Future<void> preCacheImages(BuildContext context) async {
    int count = 0;
    for (final String key in images.keys) {
      if (images[key] is AssetImage) {
        await precacheImage(images[key]!, context);
        count++;
      }
    }
    customPrint('Pre-cached $count/${images.length} images');
  }
}
