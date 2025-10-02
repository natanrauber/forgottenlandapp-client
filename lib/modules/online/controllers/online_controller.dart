import 'dart:async';

import 'package:forgottenlandapp_adapters/adapters.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get.dart';

import '../../../core/controller.dart';
import '../../../core/routes.dart';
import '../../../main.dart';
import '../../shared/controllers/worlds_controller.dart';

class OnlineController extends Controller {
  OnlineController(this.httpClient);

  final IHttpClient httpClient;

  WorldsController worldsCtrl = Get.find<WorldsController>();

  RxList<Supporter> supporters = <Supporter>[].obs;
  RxList<HighscoresEntry> rawList = <HighscoresEntry>[].obs;
  RxList<HighscoresEntry> filteredList = <HighscoresEntry>[].obs;
  RxList<HighscoresEntry> onlineTimes = <HighscoresEntry>[].obs;
  TextController searchController = TextController();
  Rx<World> world = World(name: 'All').obs;
  RxString battleyeType = LIST.battleyeType.first.obs;
  RxString location = LIST.location.first.obs;
  RxString pvpType = LIST.pvpType.first.obs;
  RxString worldType = LIST.worldType.first.obs;
  RxBool enableBattleyeType = true.obs;
  RxBool enableLocation = true.obs;
  RxBool enablePvpType = true.obs;
  RxBool enableWorldType = true.obs;

  Timer? timer;

  Future<void> getOnlineCharacters() async {
    if (isLoading.isTrue) return;
    isLoading.value = true;
    rawList.clear();

    if (worldsCtrl.list.isEmpty) await worldsCtrl.getWorlds();

    final MyHttpResponse response = await httpClient.get('${env[EnvVar.pathForgottenLandApi]}/online/now');
    if (response.success) _populateList(rawList, response);

    await filterList();
    isLoading.value = false;
  }

  void _populateList(RxList<HighscoresEntry> list, MyHttpResponse response) {
    final Online online = Online.fromJson(
      (response.dataAsMap['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
    );

    for (final OnlineEntry e in online.list) {
      final HighscoresEntry entry = HighscoresEntry.fromOnlineEntry(e);
      final World? world = worldsCtrl.list.getByName(e.world);
      if (world != null) entry.world = world;
      list.add(entry);
    }
  }

  Future<void> filterList() async {
    isLoading.value = true;

    filteredList.clear();

    for (final HighscoresEntry item in rawList) {
      bool valid = true;

      if (world.value.name != 'All') {
        if (world.value.name != item.world?.name) valid = false;
      }

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

    isLoading.value = false;
  }

  Future<void> getOnlineTimes(String day) async {
    if (isLoading.isTrue) return;
    isLoading.value = true;
    onlineTimes.clear();

    if (worldsCtrl.list.isEmpty) await worldsCtrl.getWorlds();

    final MyHttpResponse response = await httpClient.get('${env[EnvVar.pathForgottenLandApi]}/online/time/$day');
    if (response.success) _populateList(onlineTimes, response);

    isLoading.value = false;
  }

  void runTimer() {
    if (timer == null) {
      timer = Timer.periodic(
        const Duration(minutes: 5),
        (_) {
          if (Get.currentRoute != Routes.online.name) return cancelTimer();
          if (isLoading.value) return;
          getOnlineCharacters();
        },
      );
      customPrint('Periodic timer started: online [5 min]');
    }
  }

  void cancelTimer() {
    if (timer == null) return;
    timer?.cancel();
    timer = null;
    customPrint('Periodic timer stopped: online');
  }
}
