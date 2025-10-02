import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../../../core/routes.dart';
import '../../../../utils/utils.dart';
import '../../../shared/views/widgets/other/blinking_circle.dart';
import '../../../character/controllers/character_controller.dart';
import '../../controllers/online_controller.dart';

class OnlineEntryWidget extends StatefulWidget {
  const OnlineEntryWidget({
    required this.index,
    required this.item,
    required this.characterCtrl,
    required this.onlineCtrl,
  });

  final int index;
  final HighscoresEntry item;
  final CharacterController characterCtrl;
  final OnlineController onlineCtrl;

  @override
  State<OnlineEntryWidget> createState() => _OnlineEntryWidgetState();
}

class _OnlineEntryWidgetState extends State<OnlineEntryWidget> {
  @override
  Widget build(BuildContext context) => ClickableContainer(
        onTap: _onTap,
        padding: const EdgeInsets.all(12),
        color: widget.index.isEven ? AppColors.bgPaper : AppColors.bgPaper.withValues(alpha: 0.5),
        hoverColor: AppColors.bgHover,
        decoration: _decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
              child: Row(
                children: <Widget>[
                  const BlinkingCircle(size: 12),
                  const SizedBox(width: 4),
                  Expanded(child: _name()),
                  const SizedBox(width: 10),
                  _info('Level <blue>${widget.item.level ?? ''}<blue>'),
                ],
              ),
            ),
            _info(widget.item.world?.name ?? ''),
          ],
        ),
      );

  void _onTap() {
    dismissKeyboard(context);
    _loadCharacter();
  }

  Future<void> _loadCharacter() async {
    if (widget.item.name == null) return;
    widget.characterCtrl.searchCtrl.text = widget.item.name!;
    Get.toNamed<dynamic>(Routes.character.name);
    widget.characterCtrl.searchCharacter();
  }

  BoxDecoration get _decoration => BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.index == 0 ? 8 : 0),
          topRight: Radius.circular(widget.index == 0 ? 8 : 0),
          bottomLeft: Radius.circular(widget.index == widget.onlineCtrl.filteredList.length - 1 ? 8 : 0),
          bottomRight: Radius.circular(widget.index == widget.onlineCtrl.filteredList.length - 1 ? 8 : 0),
        ),
        border: widget.item.supporterTitle == null ? null : Border.all(color: AppColors.primary),
      );

  Widget _name() => Text(
        widget.item.name ?? '',
        style: const TextStyle(
          height: 20 / 14,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _info(String text) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: BetterText(
          text,
          selectable: false,
          maxLines: 1,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
        ),
      );

  // Widget _infoIcons(BuildContext context) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: <Widget>[
  //         _battleyeTypeIcon(),
  //         _pvpType(),
  //       ],
  //     );

  // Widget _infoIcon({required Widget child}) => Container(
  //       height: 20,
  //       margin: const EdgeInsets.only(bottom: 4),
  //       child: child,
  //     );

  // Widget _battleyeTypeIcon() => _infoIcon(
  //       child: Image.asset(
  //         'assets/icons/battleye_type/${widget.item.world?.battleyeType?.toLowerCase()}.png',
  //       ),
  //     );

  // Widget _pvpType() => _infoIcon(
  //       child: Image.asset(
  //         'assets/icons/pvp_type/${widget.item.world?.pvpType?.toLowerCase().replaceAll(' ', '_')}.png',
  //       ),
  //     );
}
