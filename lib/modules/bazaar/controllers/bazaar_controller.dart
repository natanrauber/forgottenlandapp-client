import 'package:forgottenlandapp_adapters/adapters.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../../core/controller.dart';
import '../../shared/controllers/worlds_controller.dart';
import '../../../main.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';

class BazaarController extends Controller {
  BazaarController({required this.httpClient, required this.worldsCtrl});

  final IHttpClient httpClient;
  final WorldsController worldsCtrl;

  RxList<Auction> auctionList = <Auction>[].obs;
  RxList<Auction> filteredList = <Auction>[].obs;

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

  Future<void> getAuctions() async {
    if (isLoading.isTrue) return;
    isLoading.value = true;
    auctionList.clear();

    if (worldsCtrl.list.isEmpty) await worldsCtrl.getWorlds();

    final MyHttpResponse response = await httpClient.get('${env[EnvVar.pathForgottenLandApi]}/bazaar');
    if (response.success) _populateList(auctionList, response);

    await filterList();
    isLoading.value = false;
  }

  void _populateList(RxList<Auction> list, MyHttpResponse response) {
    final Bazaar bazaar = Bazaar.fromJson(
      (response.dataAsMap['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
    );

    for (final Auction e in bazaar.auctions) {
      final World? world = worldsCtrl.list.getByName(e.world?.name);
      if (world != null) e.world = world;
      list.add(e);
    }
  }

  Future<void> filterList() async {
    isLoading.value = true;

    filteredList.clear();

    for (final Auction item in auctionList) {
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
}
