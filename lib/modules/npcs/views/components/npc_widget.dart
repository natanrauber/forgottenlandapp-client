import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../controllers/npcs_controller.dart';
import '../../../../theme/colors.dart';
import '../../../../views/widgets/src/images/web_image.dart';
import '../../../../views/widgets/src/other/better_text.dart';
import '../../../../views/widgets/src/other/clickable_container.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

class NpcWidget extends StatefulWidget {
  const NpcWidget(this.npc);

  final NPC npc;

  @override
  State<NpcWidget> createState() => _NpcWidgetState();
}

class _NpcWidgetState extends State<NpcWidget> {
  bool isLoading = false;
  bool expandedView = false;

  NpcsController npcsCtrl = Get.find<NpcsController>();

  @override
  Widget build(BuildContext context) => Container(
        decoration: _decoration(context),
        child: expandedView ? _expandedBody() : _header(),
      );

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.bgPaper),
      );

  Widget _header() => ClickableContainer(
        onTap: _toggleView,
        padding: const EdgeInsets.all(12),
        color: AppColors.bgPaper,
        hoverColor: AppColors.bgHover,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: <Widget>[
            _sprite(),
            const SizedBox(width: 10),
            Expanded(child: _name()),
            const SizedBox(width: 5),
            _toggleViewButton(),
          ],
        ),
      );

  Widget _expandedBody() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _header(),
          _divider(margin: const EdgeInsets.symmetric(horizontal: 12)),
          _text(),
        ],
      );

  Widget _sprite() => WebImage(
        widget.npc.imgUrl,
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
      );

  Widget _name() {
    if (expandedView) {
      return Text(
        widget.npc.name ?? '',
        style: const TextStyle(
          fontSize: 13,
          height: 16 / 13,
          color: AppColors.primary,
        ),
        textAlign: TextAlign.left,
      );
    }

    return Text(
      widget.npc.name ?? '',
      style: const TextStyle(
        fontSize: 13,
        height: 32 / 13,
        color: AppColors.primary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _divider({EdgeInsetsGeometry? margin}) => Container(
        margin: margin,
        child: const Divider(height: 1, color: AppColors.bgDefault),
      );

  Widget _text() => Padding(
        padding: const EdgeInsets.all(12),
        child: BetterText(
          _resultText,
          style: const TextStyle(
            fontSize: 12,
            height: 18 / 12,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.left,
        ),
      );

  String get _resultText {
    if (widget.npc.transcripts == null) return 'There are no records of known dialogues from this NPC.';
    final StringBuffer buffer = StringBuffer();
    final List<String> aux = (widget.npc.transcripts ?? '').split('\n');
    for (String e in aux) {
      e = e.contains('Player:') ? '<blue>${e.trim()}<blue>' : '<lBlue>${e.trim()}<lBlue>';
      buffer.write(buffer.isEmpty ? e : '\n$e');
    }
    return buffer.toString();
  }

  Widget _toggleViewButton() => ClickableContainer(
        onTap: _toggleView,
        height: 32,
        width: 32,
        alignment: Alignment.center,
        color: AppColors.bgPaper,
        hoverColor: AppColors.bgHover,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: isLoading
            ? _loading()
            : Icon(
                expandedView ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
                size: 17,
              ),
      );

  Future<void> _toggleView() async {
    if (expandedView) return setState(() => expandedView = false);
    if (!expandedView && widget.npc.transcripts != null) return setState(() => expandedView = true);

    setState(() => isLoading = true);
    await npcsCtrl.getTranscripts(widget.npc);
    setState(() {
      isLoading = false;
      expandedView = true;
    });
  }

  Widget _loading() => const SizedBox(
        height: 17,
        width: 17,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
}
