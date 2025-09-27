import 'package:flutter/material.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get.dart';

import '../../../../controllers/character_controller.dart';
import '../../../../controllers/highscores_controller.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../theme/colors.dart';
import '../../../../utils/utils.dart';
import '../../../widgets/src/other/better_text.dart';
import '../../../widgets/src/other/clickable_container.dart';

class HighscoresItemCard extends StatefulWidget {
  const HighscoresItemCard({
    required this.index,
    required this.item,
    required this.characterCtrl,
    required this.highscoresCtrl,
    required this.userCtrl,
  });

  final int index;
  final HighscoresEntry item;
  final CharacterController characterCtrl;
  final HighscoresController highscoresCtrl;
  final UserController userCtrl;

  @override
  State<HighscoresItemCard> createState() => _HighscoresItemCardState();
}

class _HighscoresItemCardState extends State<HighscoresItemCard> {
  bool expand = false;

  @override
  Widget build(BuildContext context) => ClickableContainer(
        onTap: _onTap,
        padding: const EdgeInsets.all(12),
        color: widget.index.isEven ? AppColors.bgPaper : AppColors.bgPaper.withValues(alpha: 0.5),
        hoverColor: AppColors.bgHover,
        decoration: _decoration,
        child: _body(),
      );

  Widget _body() {
    final bool wide = MediaQuery.of(context).size.width >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
          child: Row(
            children: <Widget>[
              _rank(),
              const SizedBox(width: 4),
              Expanded(child: _name()),
              if (wide) const SizedBox(width: 10),
              if (wide) _info(_value, opacity: 0.5),
            ],
          ),
        ),
        _info('${widget.item.level ?? ''} ${widget.item.world?.name ?? ''}', opacity: 0.5),
        if (!wide) _info(_value, opacity: 0.5),
        if (widget.highscoresCtrl.category.value == 'Rook Master' && expand) _skillsPosition(widget.item),
      ],
    );
  }

  void _onTap() {
    dismissKeyboard(context);
    if (widget.highscoresCtrl.category.value == 'Rook Master') return setState(() => expand = !expand);
    _loadCharacter(context);
  }

  Future<void> _loadCharacter(BuildContext context) async {
    if (widget.item.name == null) return;
    widget.characterCtrl.searchCtrl.text = widget.item.name!;
    Get.toNamed<dynamic>(Routes.character.name);
    widget.characterCtrl.searchCharacter();
  }

  BoxDecoration get _decoration => BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.index == 0 ? 8 : 0),
          topRight: Radius.circular(widget.index == 0 ? 8 : 0),
          bottomLeft: Radius.circular(widget.index == widget.highscoresCtrl.filteredList.length - 1 ? 8 : 0),
          bottomRight: Radius.circular(widget.index == widget.highscoresCtrl.filteredList.length - 1 ? 8 : 0),
        ),
        border: widget.item.supporterTitle == null ? null : Border.all(color: AppColors.primary),
      );

  Widget _rank() => Container(
        height: 18,
        width: 11 + ((_rankValue ?? '').length * 7),
        margin: const EdgeInsets.symmetric(vertical: 1),
        padding: const EdgeInsets.all(2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(),
        ),
        child: Text(
          _rankValue ?? '',
          style: const TextStyle(
            fontSize: 11,
            height: 14 / 11,
            fontWeight: FontWeight.w600,
            color: AppColors.bgDefault,
          ),
        ),
      );

  // Widget _rankImage() {
  //   final int length = (_rankValue ?? ' ').length;
  //   final AssetImage? image = widget.highscoresCtrl.images['assets/icons/rank/rank$length.png'];
  //   if (image == null) return Container();
  //   return Image(image: image);
  // }

  String? get _rankValue {
    if (_showFilteredRank) return (widget.index + 1).toString();
    return widget.item.rank?.toString();
  }

  bool get _showFilteredRank {
    // if (widget.highscoresCtrl.category.value == 'Experience gained') return true;
    // if (widget.highscoresCtrl.category.value == 'Online time') return true;
    if (widget.highscoresCtrl.searchController.text.isNotEmpty) return false;
    return widget.highscoresCtrl.rawList.length != widget.highscoresCtrl.filteredList.length;
  }

  Widget _name() => Text(
        widget.item.name ?? '',
        style: const TextStyle(
          height: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _info(String text, {double opacity = 0.75}) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: BetterText(
          text,
          selectable: false,
          maxLines: 1,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary.withValues(alpha: opacity),
          ),
        ),
      );

  String get _value {
    final bool hideData = LIST.premiumCategories.contains(widget.highscoresCtrl.category.value) &&
        widget.userCtrl.isLoggedIn.value != true;

    if (hideData) return '<primary>???<primary>';
    if (_rankName == 'Experience gained') return '$_rankName <green>+${widget.item.stringValue}<green>';
    if (_rankName == 'Online time') return _onlineTimeValue;
    return '$_rankName <blue>${widget.item.stringValue ?? ''}<blue>';
  }

  String get _rankName {
    final String name = widget.highscoresCtrl.category.value;
    if (name == 'Rook Master') return 'Total points';
    return name;
  }

  String get _onlineTimeValue {
    final String timeframe = widget.highscoresCtrl.timeframe.value;
    final int hours = int.tryParse(widget.item.onlineTime?.split('h').first ?? '') ?? 0;
    int days = 0;
    if (widget.item.onlineTime?.split('d').length != 1) {
      days = int.tryParse(widget.item.onlineTime?.split('d').first ?? '') ?? 0;
    }

    if (timeframe.contains('7')) {
      if (days >= 3) return '$_rankName <red>${widget.item.onlineTime ?? ''}<red>';
      if (days >= 2) return '$_rankName <orange>${widget.item.onlineTime ?? ''}<orange>';
      return '$_rankName <yellow>${widget.item.onlineTime ?? ''}<yellow>';
    }
    if (timeframe.contains('30')) {
      if (days >= 12) return '$_rankName <red>${widget.item.onlineTime ?? ''}<red>';
      if (days >= 8) return '$_rankName <orange>${widget.item.onlineTime ?? ''}<orange>';
      return '$_rankName <yellow>${widget.item.onlineTime ?? ''}<yellow>';
    }
    if (timeframe.contains('365')) {
      if (days >= 135) return '$_rankName <red>${widget.item.onlineTime ?? ''}<red>';
      if (days >= 90) return '$_rankName <orange>${widget.item.onlineTime ?? ''}<orange>';
      return '$_rankName <yellow>${widget.item.onlineTime ?? ''}<yellow>';
    }
    if (hours >= 9) return '$_rankName <red>${widget.item.onlineTime ?? ''}<red>';
    if (hours >= 6) return '$_rankName <orange>${widget.item.onlineTime ?? ''}<orange>';
    return '$_rankName <yellow>${widget.item.onlineTime ?? ''}<yellow>';
  }

  Widget _skillsPosition(HighscoresEntry entry) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _info(''),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _info('Parameter', opacity: 0.25),
                  _info(' Level:'),
                  _info(' Fist:'),
                  _info(' Axe:'),
                  _info(' Club:'),
                  _info(' Sword:'),
                  _info(' Distance:'),
                  _info(' Shielding:'),
                  _info(' Fishing:'),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _info('Level', opacity: 0.25),
                  _info(' ${entry.level ?? 'n/a'}'),
                  _info(' ${entry.expanded?.fist.value ?? 'n/a'}'),
                  _info(' ${entry.expanded?.axe.value ?? 'n/a'}'),
                  _info(' ${entry.expanded?.club.value ?? 'n/a'}'),
                  _info(' ${entry.expanded?.sword.value ?? 'n/a'}'),
                  _info(' ${entry.expanded?.distance.value ?? 'n/a'}'),
                  _info(' ${entry.expanded?.shielding.value ?? 'n/a'}'),
                  _info(' ${entry.expanded?.fishing.value ?? 'n/a'}'),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _info('Rank', opacity: 0.25),
                  _info(entry.expanded?.experience.value == null ? '' : ' #${entry.expanded?.experience.position}'),
                  _info(entry.expanded?.fist.value == null ? '' : ' #${entry.expanded?.fist.position}'),
                  _info(entry.expanded?.axe.value == null ? '' : ' #${entry.expanded?.axe.position}'),
                  _info(entry.expanded?.club.value == null ? '' : ' #${entry.expanded?.club.position}'),
                  _info(entry.expanded?.sword.value == null ? '' : ' #${entry.expanded?.sword.position}'),
                  _info(entry.expanded?.distance.value == null ? '' : ' #${entry.expanded?.distance.position}'),
                  _info(entry.expanded?.shielding.value == null ? '' : ' #${entry.expanded?.shielding.position}'),
                  _info(entry.expanded?.fishing.value == null ? '' : ' #${entry.expanded?.fishing.position}'),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _info('Points', opacity: 0.25),
                  _info(entry.expanded?.experience.value == null ? '' : ' +${entry.expanded?.experience.points}'),
                  _info(entry.expanded?.fist.value == null ? '' : ' +${entry.expanded?.fist.points}'),
                  _info(entry.expanded?.axe.value == null ? '' : ' +${entry.expanded?.axe.points}'),
                  _info(entry.expanded?.club.value == null ? '' : ' +${entry.expanded?.club.points}'),
                  _info(entry.expanded?.sword.value == null ? '' : ' +${entry.expanded?.sword.points}'),
                  _info(entry.expanded?.distance.value == null ? '' : ' +${entry.expanded?.distance.points}'),
                  _info(entry.expanded?.shielding.value == null ? '' : ' +${entry.expanded?.shielding.points}'),
                  _info(entry.expanded?.fishing.value == null ? '' : ' +${entry.expanded?.fishing.points}'),
                ],
              ),
            ],
          ),
        ],
      );

  // Widget _infoIcons(BuildContext context) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: <Widget>[
  //         if (_showGlobalRank) _globalRank(),
  //         _battleyeTypeIcon(),
  //         _pvpType(),
  //       ],
  //     );

  // Widget _infoIcon({required Widget child}) => Container(
  //       height: 20,
  //       margin: const EdgeInsets.only(bottom: 4),
  //       child: child,
  //     );

  // Widget _battleyeTypeIcon() {
  //   final String? type = widget.item.world?.battleyeType?.toLowerCase();
  //   final AssetImage? image = widget.highscoresCtrl.images['assets/icons/battleye_type/$type.png'];
  //   if (image == null) return _infoIcon(child: Container());
  //   return _infoIcon(child: Image(image: image));
  // }

  // Widget _pvpType() {
  //   final String? type = widget.item.world?.pvpType?.toLowerCase().replaceAll(' ', '_');
  //   final AssetImage? image = widget.highscoresCtrl.images['assets/icons/pvp_type/$type.png'];
  //   if (image == null) return _infoIcon(child: Container());
  //   return _infoIcon(child: Image(image: image));
  // }

  // Widget _globalRank() => _infoIcon(
  //       child: Stack(
  //         alignment: Alignment.center,
  //         children: <Widget>[
  //           _globalRankImage(),
  //           Container(
  //             padding: const EdgeInsets.only(left: 16),
  //             child: Text(
  //               _globalRankValue ?? '',
  //               style: const TextStyle(
  //                 fontSize: 11,
  //                 height: 13 / 11,
  //                 fontWeight: FontWeight.w600,
  //                 color: AppColors.bgDefault,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );

  // Widget _globalRankImage() {
  //   final int length = (_globalRankValue ?? ' ').length;
  //   final AssetImage? image = widget.highscoresCtrl.images['assets/icons/rank/globalrank$length.png'];
  //   if (image == null) return Container();
  //   return Image(image: image);
  // }

  // String? get _globalRankValue {
  //   if (widget.highscoresCtrl.category.value == 'Experience gained') {
  //     return (widget.highscoresCtrl.rawList.indexOf(widget.item) + 1).toString();
  //   }
  //   if (widget.highscoresCtrl.category.value == 'Online time') {
  //     return (widget.highscoresCtrl.rawList.indexOf(widget.item) + 1).toString();
  //   }
  //   return widget.item.rank.toString();
  // }
}
