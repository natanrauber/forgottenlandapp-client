import 'package:flutter/material.dart';
import '../../../../controllers/online_controller.dart';
import '../../../../controllers/worlds_controller.dart';
import '../../../../theme/colors.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/src/images/svg_image.dart';
import '../../../widgets/src/other/clickable_container.dart';
import '../../../widgets/widgets.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';
import 'package:forgottenlandapp_utils/utils.dart';

class OnlineFilters extends StatefulWidget {
  @override
  State<OnlineFilters> createState() => _OnlineFiltersState();
}

class _OnlineFiltersState extends State<OnlineFilters> {
  final OnlineController onlineCtrl = Get.find<OnlineController>();
  final WorldsController worldsCtrl = Get.find<WorldsController>();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _selectedFilters(),
                  const SizedBox(width: 20),
                  _amount(),
                ],
              ),

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
    bool bigger = false,
    EdgeInsets margin = const EdgeInsets.only(right: 10),
  }) =>
      Container(
        width: _dropdownWidth,
        margin: margin,
        child: CustomDropdown<T>(
          loading: onlineCtrl.isLoading.value,
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
    int? amount = onlineCtrl.rawList
        .where((HighscoresEntry e) => e.world?.name?.toLowerCase() == world.name?.toLowerCase())
        .toList()
        .length;
    if (world.name == 'All') amount = onlineCtrl.rawList.length;
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

  Widget _searchBar() => CustomTextField(
        loading: onlineCtrl.isLoading.isTrue,
        label: 'Search',
        controller: onlineCtrl.searchController,
        onEditingComplete: _search,
      );

  void _search() {
    dismissKeyboard(context);
    onlineCtrl.searchController.text = onlineCtrl.searchController.text.trim();
    onlineCtrl.filterList();
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
            color: onlineCtrl.isLoading.value ? AppColors.textSecondary : AppColors.primary,
          ),
        ),
      );

  Widget _clearButton() => ClickableContainer(
        onTap: onlineCtrl.isLoading.value ? null : _clearFilters,
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
            color: onlineCtrl.isLoading.value ? AppColors.textSecondary : AppColors.primary,
          ),
        ),
      );

  void _clearFilters() {
    onlineCtrl.world.value = World(name: 'All');
    onlineCtrl.battleyeType.value = 'All';
    onlineCtrl.location.value = 'All';
    onlineCtrl.pvpType.value = 'All';
    onlineCtrl.worldType.value = 'All';

    onlineCtrl.enableBattleyeType.value = true;
    onlineCtrl.enableLocation.value = true;
    onlineCtrl.enablePvpType.value = true;
    onlineCtrl.enableWorldType.value = true;

    onlineCtrl.searchController.clear();
    onlineCtrl.filterList();
  }

  Widget _selectedFilters() => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
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
    String? text = 'Filter: Online';

    if (onlineCtrl.world.value.name != 'All') return '$text, ${onlineCtrl.world.value}.';
    if (onlineCtrl.battleyeType.value != 'All') text = '$text, Battleye ${onlineCtrl.battleyeType.value}';
    if (onlineCtrl.location.value != 'All') text = '$text, ${onlineCtrl.location.value}';
    if (onlineCtrl.pvpType.value != 'All') text = '$text, ${onlineCtrl.pvpType.value}';
    if (onlineCtrl.worldType.value != 'All') text = '$text, ${onlineCtrl.worldType.value} World';
    if (onlineCtrl.searchController.text.isNotEmpty) text = '$text, "${onlineCtrl.searchController.text}"';

    return '$text.';
  }

  bool get anyFilterSelected => _selectedFiltersText.contains(',');

  Widget _amount() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        child: Text(
          _amountText,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      );

  String get _amountText => onlineCtrl.filteredList.isEmpty ? '' : '[${onlineCtrl.filteredList.length}]';

  Widget _world() => _dropdown<World>(
        labelText: 'World',
        selectedItem: onlineCtrl.world.value,
        itemList: _worldList,
        onChanged: (World? value) async {
          if (value is World) {
            if (value.name == 'All') {
              onlineCtrl.enableBattleyeType.value = true;
              onlineCtrl.enableLocation.value = true;
              onlineCtrl.enablePvpType.value = true;
              onlineCtrl.enableWorldType.value = true;
            } else {
              onlineCtrl.enableBattleyeType.value = false;
              onlineCtrl.enableLocation.value = false;
              onlineCtrl.enablePvpType.value = false;
              onlineCtrl.enableWorldType.value = false;
            }
            onlineCtrl.world.value = value;
            await onlineCtrl.filterList();
          }
        },
      );

  List<World> get _worldList {
    final List<World> list = List<World>.from(worldsCtrl.list);
    final List<World> removalList = <World>[];

    if (onlineCtrl.battleyeType.value != 'All') {
      for (final World world in worldsCtrl.list) {
        if (onlineCtrl.battleyeType.value != world.battleyeType) removalList.add(world);
      }
    }

    if (onlineCtrl.location.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.location != onlineCtrl.location.value) {
          removalList.add(item);
        }
      }
    }

    if (onlineCtrl.pvpType.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.pvpType?.toLowerCase() != onlineCtrl.pvpType.value.toLowerCase()) {
          removalList.add(item);
        }
      }
    }

    if (onlineCtrl.worldType.value != 'All') {
      for (final World item in worldsCtrl.list) {
        if (item.worldType?.toLowerCase() != onlineCtrl.worldType.value.toLowerCase()) {
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
        enabled: onlineCtrl.enableBattleyeType.value,
        labelText: 'Battleye Type',
        selectedItem: onlineCtrl.battleyeType.value,
        itemList: LIST.battleyeType,
        onChanged: (String? value) async {
          if (value is String) {
            onlineCtrl.battleyeType.value = value;
            await onlineCtrl.filterList();
          }
        },
      );

  Widget _location() => _dropdown<String>(
        enabled: onlineCtrl.enableLocation.value,
        labelText: 'Location',
        selectedItem: onlineCtrl.location.value,
        itemList: LIST.location,
        onChanged: (String? value) async {
          if (value is String) {
            onlineCtrl.location.value = value;
            await onlineCtrl.filterList();
          }
        },
      );

  Widget _pvpType() => _dropdown<String>(
        enabled: onlineCtrl.enablePvpType.value,
        labelText: 'Pvp Type',
        selectedItem: onlineCtrl.pvpType.value,
        itemList: LIST.pvpType,
        onChanged: (String? value) async {
          if (value is String) {
            onlineCtrl.pvpType.value = value;
            await onlineCtrl.filterList();
          }
        },
      );

  Widget _worldType() => _dropdown<String>(
        enabled: onlineCtrl.enableWorldType.value,
        labelText: 'World Type',
        selectedItem: onlineCtrl.worldType.value,
        itemList: LIST.worldType,
        onChanged: (String? value) async {
          if (value is String) {
            onlineCtrl.worldType.value = value;
            await onlineCtrl.filterList();
          }
        },
      );
}
