import 'package:flutter/cupertino.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../controllers/character_controller.dart';
import '../../../../theme/colors.dart';
import '../../../../utils/utils.dart';
import '../../../../views/widgets/src/images/web_image.dart';
import '../../../../views/widgets/src/other/better_text.dart';

class StreamWidget extends StatefulWidget {
  const StreamWidget(this.item);

  final LiveStream item;

  @override
  State<StreamWidget> createState() => _StreamWidgetState();
}

class _StreamWidgetState extends State<StreamWidget> {
  final CharacterController characterCtrl = Get.find<CharacterController>();

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
            decoration: _decoration(context),
            child: MediaQuery.of(context).size.width < 770 ? _verticalLayout() : _horizontalLayout(),
          ),
        ),
      );

  Widget _horizontalLayout() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //
          _thumbnail(height: 200),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _userNameRow(),
                    _viewerCountRow(),
                  ],
                ),
                _title(),
                _tags(widget.item.tags, 10),
                if (_tagCount(widget.item.tags) < widget.item.tags.length)
                  _tags(widget.item.tags.sublist(_tagCount(widget.item.tags)), 5),
              ],
            ),
          ),
        ],
      );

  Widget _verticalLayout() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //
          _thumbnail(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _userNameRow(),
              _viewerCountRow(),
            ],
          ),
          _title(),
          _tags(widget.item.tags, 10),
          if (_tagCount(widget.item.tags) < widget.item.tags.length)
            _tags(widget.item.tags.sublist(_tagCount(widget.item.tags)), 5),
        ],
      );

  Widget _thumbnail({double? height}) => WebImage(
        widget.item.thumbUrl,
        height: height,
        borderRadius: BorderRadius.circular(6),
        borderThickness: 1,
        borderColor: AppColors.primary,
      );

  Widget _userNameRow() => SizedBox(
        height: 20,
        child: Row(
          children: <Widget>[
            const Icon(CupertinoIcons.person_fill, size: 18),
            const SizedBox(width: 4),
            _name(),
          ],
        ),
      );

  Widget _viewerCountRow() => SizedBox(
        height: 20,
        child: Row(
          children: <Widget>[
            const Icon(CupertinoIcons.eye_fill, size: 16),
            const SizedBox(width: 4),
            _viewerCount(),
          ],
        ),
      );

  void _onTap() {
    dismissKeyboard(context);
    _openLivestreamExternal();
  }

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.bgPaper),
      );

  Widget _name() => Text(
        widget.item.userName ?? '',
        style: const TextStyle(
          height: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _viewerCount() => Text(
        widget.item.viewerCount?.toString() ?? '',
        style: const TextStyle(
          height: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _title() => Container(
        margin: const EdgeInsets.only(top: 8),
        child: BetterText(
          widget.item.title ?? '',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      );

  Widget _tags(List<String> tags, double marginTop) => Container(
        margin: EdgeInsets.only(top: marginTop),
        height: 20,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _tagCount(tags),
          itemBuilder: (_, int index) => _tagBuilder(tags, index),
        ),
      );

  int _tagCount(List<String> tags) {
    int count = 0;
    String result = '';
    for (String tag in tags) {
      if (tag.length > 10) tag = tag.substring(0, 10);
      // ignore: use_string_buffers
      result = '$result$tag ';
      if (result.length > (MediaQuery.of(context).size.width > 770 ? 35 : 30)) return count;
      count++;
    }
    return count;
  }

  Widget _tagBuilder(List<String> tags, int index) {
    final String tag = tags[index];

    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.bgDefault,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: <Widget>[
          Text(
            _tagText(tag),
            style: TextStyle(
              fontSize: 10,
              height: 20 / 10,
              color: tag == 'Verified' ? AppColors.green : AppColors.textSecondary,
            ),
          ),
          if (tag.length > 10) const SizedBox(width: 1),
          if (tag.length > 10)
            const Text(
              '...',
              style: TextStyle(
                fontSize: 10,
                height: 20 / 10,
                letterSpacing: -4,
                color: AppColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  String _tagText(String tag) {
    if (tag.length > 10) return tag.substring(0, 8);
    if (tag == 'Verified') return '$tag ✔️';
    return tag;
  }

  Future<void> _openLivestreamExternal() async {
    launchUrlString('https://twitch.tv/${widget.item.userName?.toLowerCase() ?? ''}');
  }
}
