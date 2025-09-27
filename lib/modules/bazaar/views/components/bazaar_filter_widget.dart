import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get.dart';

import '../../../../controllers/worlds_controller.dart';
import '../../../../theme/colors.dart';
import '../../../../utils/utils.dart';
import '../../../../views/widgets/src/images/svg_image.dart';
import '../../../../views/widgets/widgets.dart';
import '../../controllers/bazaar_controller.dart';

class BazaarFilters extends StatefulWidget {
  @override
  State<BazaarFilters> createState() => _BazaarFiltersState();
}

class _BazaarFiltersState extends State<BazaarFilters> {
  final BazaarController bazaarCtrl = Get.find<BazaarController>();
  final WorldsController worldsCtrl = Get.find<WorldsController>();

  Timer timer = Timer(Duration.zero, () {});

  @override
  Widget build(BuildContext context) => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //
            SizedBox(
              height: 53,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  //
                  _world(),

                  const SizedBox(width: 10),

                  _battleyeType(),

                  const SizedBox(width: 10),

                  _location(),

                  const SizedBox(width: 10),

                  _pvpType(),

                  const SizedBox(width: 10),

                  _worldType(),
                ],
              ),
            ),

            const SizedBox(height: 5),

            Container(
              height: 53,
              padding: const EdgeInsets.only(top: 5),
              child: _searchBar(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _selectedFilters(),
                const SizedBox(width: 20),
                _amount(),
              ],
            ),
          ],
        ),
      );

  Widget _dropdown<T>({
    bool enabled = true,
    required String labelText,
    T? selectedItem,
    required List<T>? itemList,
    void Function(T?)? onChanged,
    bool bigger = false,
  }) =>
      SizedBox(
        width: _dropdownWidth(bigger),
        child: CustomDropdown<T>(
          loading: bazaarCtrl.isLoading.value,
          enabled: enabled,
          labelText: labelText,
          selectedItem: selectedItem,
          itemList: itemList,
          popupItemBuilder: (_, T? value, __) => _popupItemBuilder(value, enabled, selectedItem, labelText),
          onChanged: (T? value) {
            if (value == selectedItem) return;
            onChanged?.call(value);
          },
        ),
      );

  double _dropdownWidth(bool bigger) {
    final double width = MediaQuery.of(context).size.width;

    if (width < 460) return (bigger ? 1.5 : 1) * (width - 50) / 2;
    if (width < 630) return (bigger ? 1.5 : 1) * (width - 60) / 3;
    if (width < 800) return (bigger ? 1.5 : 1) * (width - 70) / 4;
    return (bigger ? 1.5 : 1) * (800 - 70) / 4;
  }

  Widget _popupItemBuilder(dynamic value, bool enabled, dynamic selectedItem, String labelText) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 25,
        ),
        child: Row(
          children: <Widget>[
            //
            _popupItemText(value, selectedItem),

            if (value is World) _worldOnlineAmount(value, selectedItem),

            Flexible(child: Container()),

            if (value is World && value.pvpType != null) _pvpTypeIcon(value),
            if (labelText.toLowerCase().contains('pvp')) _pvpTypeIcon(value),

            if (value is World && value.battleyeType != null) _battleyeTypeIcon(value),
            if (labelText.toLowerCase().contains('battleye')) _battleyeTypeIcon(value),

            if (value is World && value.location != null) _locationIcon(value.location),
            if (LIST.location.contains(value)) _locationIcon(value),
          ],
        ),
      );

  Widget _popupItemText(dynamic value, dynamic selectedItem) => Text(
        value.toString(),
        style: TextStyle(
          fontSize: 14,
          color: _popupItemTextColor(value, selectedItem),
        ),
      );

  Color _popupItemTextColor(dynamic value, dynamic selectedItem) {
    final dynamic a = value;
    final dynamic b = selectedItem;
    if (a is World && b is World) return a.name == b.name ? AppColors.primary : AppColors.textPrimary;
    return a == b ? AppColors.primary : AppColors.textPrimary;
  }

  Widget _worldOnlineAmount(World value, dynamic selectedItem) => Text(
        ' [${_onlineAmount(value)}]',
        style: TextStyle(
          fontSize: 14,
          color: _worldOnlineAmountTextColor(value, selectedItem),
        ),
      );

  int _onlineAmount(World world) {
    int? amount = bazaarCtrl.auctionList
        .where((Auction e) => e.world?.name?.toLowerCase() == world.name?.toLowerCase())
        .toList()
        .length;
    if (world.name == 'All') amount = bazaarCtrl.auctionList.length;
    return amount;
  }

  Color _worldOnlineAmountTextColor(dynamic value, dynamic selectedItem) {
    final dynamic a = value;
    final dynamic b = selectedItem;
    if (a is World && b is World) return a.name == b.name ? AppColors.primary : AppColors.textSecondary;
    return a == b ? AppColors.primary : AppColors.textSecondary;
  }

  Widget _infoIcon({required Widget child, Color? backgroundColor, EdgeInsets? padding}) => Container(
        height: 20,
        width: 20,
        margin: const EdgeInsets.only(left: 4),
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: child,
      );

  Widget _pvpTypeIcon(dynamic value) {
    String image = '${value?.toString().toLowerCase().replaceAll(' ', '_')}';
    if (value is World) image = '${value.pvpType?.toLowerCase().replaceAll(' ', '_')}';
    if (image == 'all') return Container();
    return _infoIcon(child: Image.asset('assets/icons/pvp_type/$image.png'));
  }

  Widget _battleyeTypeIcon(dynamic value) {
    String image = '${value?.toString().toLowerCase().replaceAll(' ', '_')}';
    if (value is World) image = '${value.battleyeType?.toLowerCase().replaceAll(' ', '_')}';
    if (image == 'all') return Container();
    return _infoIcon(child: Image.asset('assets/icons/battleye_type/$image.png'));
  }

  Widget _locationIcon(dynamic value) {
    final Map<String, String> map = <String, String>{
      'Europe': 'EU',
      'North America': 'NA',
      'South America': 'SA',
    };
    if (value is! String) return Container();
    if (!map.containsKey(value)) return Container();
    return _infoIcon(
      backgroundColor: Colors.black87,
      padding: const EdgeInsets.all(1.5),
      child: SvgImage(asset: 'assets/icons/location/${map[value]}.svg'),
    );
  }

  Widget _searchBar() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomTextField(
          loading: bazaarCtrl.isLoading.isTrue,
          label: 'Search',
          controller: bazaarCtrl.searchController,
          onChanged: (_) {
            if (timer.isActive) timer.cancel();

            timer = Timer(
              const Duration(seconds: 1),
              () => _search(),
            );
          },
        ),
      );

  void _search() {
    dismissKeyboard(context);
    bazaarCtrl.searchController.text = bazaarCtrl.searchController.text.trim();
    bazaarCtrl.filterList();
  }

  Widget _selectedFilters() => Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
          child: Text(
            _selectedFiltersText,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );

  String get _selectedFiltersText {
    String? text = 'Filter: Char Bazaar';

    if (bazaarCtrl.world.value.name != 'All') return '$text, ${bazaarCtrl.world.value}.';
    if (bazaarCtrl.battleyeType.value != 'All') text = '$text, Battleye ${bazaarCtrl.battleyeType.value}';
    if (bazaarCtrl.location.value != 'All') text = '$text, ${bazaarCtrl.location.value}';
    if (bazaarCtrl.pvpType.value != 'All') text = '$text, ${bazaarCtrl.pvpType.value}';
    if (bazaarCtrl.worldType.value != 'All') text = '$text, ${bazaarCtrl.worldType.value} World';

    return '$text.';
  }

  Widget _amount() => Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
        child: Text(
          _amountText,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      );

  String get _amountText => bazaarCtrl.filteredList.isEmpty ? '' : '[${bazaarCtrl.filteredList.length}]';

  Widget _world() => _dropdown<World>(
        labelText: 'World',
        selectedItem: bazaarCtrl.world.value,
        itemList: _worldList,
        onChanged: (World? value) async {
          if (value is World) {
            if (value.name == 'All') {
              bazaarCtrl.enableBattleyeType.value = true;
              bazaarCtrl.enableLocation.value = true;
              bazaarCtrl.enablePvpType.value = true;
              bazaarCtrl.enableWorldType.value = true;
            } else {
              bazaarCtrl.enableBattleyeType.value = false;
              bazaarCtrl.enableLocation.value = false;
              bazaarCtrl.enablePvpType.value = false;
              bazaarCtrl.enableWorldType.value = false;
            }
            bazaarCtrl.world.value = value;
            await bazaarCtrl.filterList();
          }
        },
      );

  List<World> get _worldList {
    final List<World> list = List<World>.from(worldsCtrl.list);
    final List<World> removalList = <World>[];

    if (bazaarCtrl.battleyeType.value != 'All') {
      for (final World world in worldsCtrl.list) {
        if (bazaarCtrl.battleyeType.value != world.battleyeType) removalList.add(world);
      }
    }

    if (bazaarCtrl.location.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.location != bazaarCtrl.location.value) {
          removalList.add(item);
        }
      }
    }

    if (bazaarCtrl.pvpType.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.pvpType?.toLowerCase() != bazaarCtrl.pvpType.value.toLowerCase()) {
          removalList.add(item);
        }
      }
    }

    if (bazaarCtrl.worldType.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.worldType?.toLowerCase() != bazaarCtrl.worldType.value.toLowerCase()) {
          removalList.add(item);
        }
      }
    }

    list.sort((World a, World b) => _compareWorlds(a, b));
    list.removeWhere((World e) => e.name == 'All');
    list.insert(0, World(name: 'All'));
    removalList.removeWhere((World e) => e.name == 'All');
    return list.where((World e) => !removalList.contains(e)).toList();
  }

  int _compareWorlds(World a, World b) {
    int result = _onlineAmount(b).compareTo(_onlineAmount(a));
    if (result == 0) result = (a.name ?? '').compareTo(b.name ?? '');
    return result;
  }

  Widget _battleyeType() => _dropdown<String>(
        enabled: bazaarCtrl.enableBattleyeType.value,
        labelText: 'Battleye Type',
        selectedItem: bazaarCtrl.battleyeType.value,
        itemList: LIST.battleyeType,
        onChanged: (String? value) async {
          if (value is String) {
            bazaarCtrl.battleyeType.value = value;
            await bazaarCtrl.filterList();
          }
        },
      );

  Widget _location() => _dropdown<String>(
        enabled: bazaarCtrl.enableLocation.value,
        labelText: 'Location',
        selectedItem: bazaarCtrl.location.value,
        itemList: LIST.location,
        onChanged: (String? value) async {
          if (value is String) {
            bazaarCtrl.location.value = value;
            await bazaarCtrl.filterList();
          }
        },
      );

  Widget _pvpType() => _dropdown<String>(
        enabled: bazaarCtrl.enablePvpType.value,
        labelText: 'Pvp Type',
        selectedItem: bazaarCtrl.pvpType.value,
        itemList: LIST.pvpType,
        onChanged: (String? value) async {
          if (value is String) {
            bazaarCtrl.pvpType.value = value;
            await bazaarCtrl.filterList();
          }
        },
      );

  Widget _worldType() => _dropdown<String>(
        enabled: bazaarCtrl.enableWorldType.value,
        labelText: 'World Type',
        selectedItem: bazaarCtrl.worldType.value,
        itemList: LIST.worldType,
        onChanged: (String? value) async {
          if (value is String) {
            bazaarCtrl.worldType.value = value;
            await bazaarCtrl.filterList();
          }
        },
      );
}
