import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get.dart';

import '../../../shared/controllers/worlds_controller.dart';
import '../../../../utils/utils.dart';
import '../../controllers/highscores_controller.dart';

class HighscoresFilterBar extends StatefulWidget {
  @override
  State<HighscoresFilterBar> createState() => _HighscoresFilterBarState();
}

class _HighscoresFilterBarState extends State<HighscoresFilterBar> {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
  final WorldsController worldsCtrl = Get.find<WorldsController>();

  Future<void> _loadHighscores({bool newPage = false}) async {
    if (highscoresCtrl.supporters.isEmpty) await highscoresCtrl.getSupporters();
    if (highscoresCtrl.hidden.isEmpty) await highscoresCtrl.getHidden();
    await highscoresCtrl.loadHighscores(newPage: newPage);
  }

  @override
  Widget build(BuildContext context) => Obx(
        () => Container(
          decoration: BoxDecoration(
            color: AppColors.bgDefault,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //
              const SizedBox(height: 11),

              SizedBox(
                height: 53,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    _category(),
                    _timeframe(),
                    _world(),
                    _battleyeType(),
                    _location(),
                    _pvpType(),
                    _worldType(),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Container(
                height: 53,
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: _searchBar()),
                    const SizedBox(width: 10),
                    _searchButton(),
                    if (anyFilterSelected) const SizedBox(width: 10),
                    if (anyFilterSelected) _clearButton(),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              _selectedFilters(),

              if (highscoresCtrl.rankLastUpdate != null) const SizedBox(height: 3),
              if (highscoresCtrl.rankLastUpdate != null) _lastUpdated(),

              const SizedBox(height: 12),
            ],
          ),
        ),
      );

  Widget _dropdown<T>({
    bool enabled = true,
    required String labelText,
    T? selectedItem,
    required List<T>? itemList,
    void Function(T?)? onChanged,
    EdgeInsets margin = const EdgeInsets.only(right: 10),
  }) =>
      Container(
        width: _dropdownWidth,
        margin: margin,
        child: CustomDropdown<T>(
          loading: highscoresCtrl.isLoading.value,
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

  double get _dropdownWidth {
    final double width = MediaQuery.of(context).size.width;
    if (width < 460) return (width - 42) / 2;
    if (width < 630) return (width - 52) / 3;
    if (width < 800) return (width - 62) / 4;
    return (800 - 62) / 4;
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

  Widget _searchBar() => CustomTextField(
        loading: highscoresCtrl.isLoading.isTrue,
        label: 'Search',
        controller: highscoresCtrl.searchController,
        onEditingComplete: _search,
      );

  void _search() {
    dismissKeyboard(context);
    highscoresCtrl.searchController.text = highscoresCtrl.searchController.text.trim();
    highscoresCtrl.filterList();
  }

  Widget _searchButton() => ClickableContainer(
        onTap: _search,
        height: 48,
        constraints: BoxConstraints(minWidth: (_dropdownWidth - 10) / 2),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        color: AppColors.bgPaper,
        hoverColor: AppColors.bgDefault,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Search',
          style: TextStyle(
            color: highscoresCtrl.isLoading.value ? AppColors.textSecondary : AppColors.primary,
          ),
        ),
      );

  Widget _clearButton() => ClickableContainer(
        onTap: highscoresCtrl.isLoading.value ? null : _clearFilters,
        height: 48,
        constraints: BoxConstraints(minWidth: (_dropdownWidth - 10) / 2),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        color: AppColors.bgPaper,
        hoverColor: AppColors.bgHover,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Clear',
          style: TextStyle(
            color: highscoresCtrl.isLoading.value ? AppColors.textSecondary : AppColors.primary,
          ),
        ),
      );

  void _clearFilters() {
    highscoresCtrl.world.value = World(name: 'All');
    highscoresCtrl.battleyeType.value = 'All';
    highscoresCtrl.location.value = 'All';
    highscoresCtrl.pvpType.value = 'All';
    highscoresCtrl.worldType.value = 'All';

    highscoresCtrl.enableBattleyeType.value = true;
    highscoresCtrl.enableLocation.value = true;
    highscoresCtrl.enablePvpType.value = true;
    highscoresCtrl.enableWorldType.value = true;

    highscoresCtrl.searchController.clear();

    _loadHighscores();
  }

  Widget _selectedFilters() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        child: Text(
          _selectedFiltersText,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      );

  String get _selectedFiltersText {
    String? text = 'Filter: ${highscoresCtrl.category.value}';

    if (highscoresCtrl.category.value == 'Experience gained') text = '$text, ${highscoresCtrl.timeframe.value}';
    if (highscoresCtrl.category.value == 'Online time') text = '$text, ${highscoresCtrl.timeframe.value}';
    if (highscoresCtrl.world.value.name != 'All') return '$text, ${highscoresCtrl.world.value}.';
    if (highscoresCtrl.battleyeType.value != 'All') text = '$text, Battleye ${highscoresCtrl.battleyeType.value}';
    if (highscoresCtrl.location.value != 'All') text = '$text, ${highscoresCtrl.location.value}';
    if (highscoresCtrl.pvpType.value != 'All') text = '$text, ${highscoresCtrl.pvpType.value}';
    if (highscoresCtrl.worldType.value != 'All') text = '$text, ${highscoresCtrl.worldType.value} World';
    if (highscoresCtrl.searchController.text.isNotEmpty) text = '$text, "${highscoresCtrl.searchController.text}"';

    return '$text.';
  }

  bool get anyFilterSelected {
    if (highscoresCtrl.category.value == 'Experience gained') return _selectedFiltersText.split(',').length > 2;
    if (highscoresCtrl.category.value == 'Online time') return _selectedFiltersText.split(',').length > 2;
    return _selectedFiltersText.contains(',');
  }

  Widget _lastUpdated() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        child: Text(
          'Updated: ${highscoresCtrl.rankLastUpdate?.replaceAll('-', '.')}',
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      );

  Widget _category() => _dropdown<String>(
        labelText: 'Category',
        selectedItem: highscoresCtrl.category.value,
        itemList: LIST.category,
        onChanged: (String? value) async {
          if (value is! String) return;
          if (value == 'Experience gained' || value == 'Online time') {
            final String category = value.toLowerCase().replaceAll(' ', '');
            final String timeframe = highscoresCtrl.timeframe.value.toLowerCase().replaceAll(' ', '');
            return Get.toNamed('/highscores/$category/$timeframe');
          }
          return Get.toNamed('/highscores/${value.toLowerCase().replaceAll(' ', '')}');
        },
      );

  Widget _timeframe() => Obx(
        () {
          final String category = highscoresCtrl.category.value;
          if (category != 'Experience gained' && category != 'Online time') return Container();
          return _dropdown<String>(
            labelText: 'Timeframe',
            selectedItem: highscoresCtrl.timeframe.value,
            itemList: LIST.timeframe,
            onChanged: (String? value) async {
              if (value is! String) return;
              final String category = highscoresCtrl.category.value.toLowerCase().replaceAll(' ', '');
              final String timeframe = value.toLowerCase().replaceAll(' ', '');
              Get.toNamed<dynamic>('/highscores/$category/$timeframe');
            },
          );
        },
      );

  Widget _world() => _dropdown<World>(
        labelText: 'World',
        selectedItem: highscoresCtrl.world.value,
        itemList: _worldList,
        onChanged: (World? value) async {
          if (value is World) {
            if (value.name == 'All') {
              highscoresCtrl.enableBattleyeType.value = true;
              highscoresCtrl.enableLocation.value = true;
              highscoresCtrl.enablePvpType.value = true;
              highscoresCtrl.enableWorldType.value = true;
            } else {
              highscoresCtrl.enableBattleyeType.value = false;
              highscoresCtrl.enableLocation.value = false;
              highscoresCtrl.enablePvpType.value = false;
              highscoresCtrl.enableWorldType.value = false;
            }
            highscoresCtrl.world.value = value;
            await _loadHighscores();
          }
        },
      );

  List<World> get _worldList {
    final List<World> list = List<World>.from(worldsCtrl.list);
    final List<World> removalList = <World>[];

    if (highscoresCtrl.battleyeType.value != 'All') {
      for (final World world in worldsCtrl.list) {
        if (highscoresCtrl.battleyeType.value != world.battleyeType) removalList.add(world);
      }
    }

    if (highscoresCtrl.location.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.location != highscoresCtrl.location.value) {
          removalList.add(item);
        }
      }
    }

    if (highscoresCtrl.pvpType.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.pvpType?.toLowerCase() != highscoresCtrl.pvpType.value.toLowerCase()) {
          removalList.add(item);
        }
      }
    }

    if (highscoresCtrl.worldType.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.worldType?.toLowerCase() != highscoresCtrl.worldType.value.toLowerCase()) {
          removalList.add(item);
        }
      }
    }

    removalList.removeWhere((World e) => e.name == 'All');

    return list.where((World e) => !removalList.contains(e)).toList();
  }

  Widget _battleyeType() => _dropdown<String>(
        enabled: highscoresCtrl.enableBattleyeType.value,
        labelText: 'Battleye Type',
        selectedItem: highscoresCtrl.battleyeType.value,
        itemList: LIST.battleyeType,
        onChanged: (String? value) async {
          if (value is String) {
            highscoresCtrl.battleyeType.value = value;
            highscoresCtrl.filterList();
          }
        },
      );

  Widget _location() => _dropdown<String>(
        enabled: highscoresCtrl.enableLocation.value,
        labelText: 'Location',
        selectedItem: highscoresCtrl.location.value,
        itemList: LIST.location,
        onChanged: (String? value) async {
          if (value is String) {
            highscoresCtrl.location.value = value;
            await highscoresCtrl.filterList();
          }
        },
      );

  Widget _pvpType() => _dropdown<String>(
        enabled: highscoresCtrl.enablePvpType.value,
        labelText: 'Pvp Type',
        selectedItem: highscoresCtrl.pvpType.value,
        itemList: LIST.pvpType,
        onChanged: (String? value) async {
          if (value is String) {
            highscoresCtrl.pvpType.value = value;
            await highscoresCtrl.filterList();
          }
        },
      );

  Widget _worldType() => _dropdown<String>(
        margin: EdgeInsets.zero,
        enabled: highscoresCtrl.enableWorldType.value,
        labelText: 'World Type',
        selectedItem: highscoresCtrl.worldType.value,
        itemList: LIST.worldType,
        onChanged: (String? value) async {
          if (value is String) {
            highscoresCtrl.worldType.value = value;
            await highscoresCtrl.filterList();
          }
        },
      );
}
