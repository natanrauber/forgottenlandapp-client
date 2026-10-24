import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';

import '../../../shared/views/widgets/other/blinking_circle.dart';

class OverviewWidget extends StatefulWidget {
  const OverviewWidget({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.title,
    required this.onTap,
    required this.list,
    this.customValueText,
    this.showBar = false,
    this.barColorFirst = AppColors.blue,
    this.barColorLast = AppColors.blue,
    this.topValue,
  });

  final bool isEnabled;
  final bool isLoading;
  final String title;
  final dynamic Function()? onTap;
  final List<HighscoresEntry> list;
  final String Function(HighscoresEntry item)? customValueText;
  final bool showBar;
  final Color barColorFirst;
  final Color barColorLast;
  final int? topValue;

  @override
  State<OverviewWidget> createState() => _OverviewWidgetState();
}

class _OverviewWidgetState extends State<OverviewWidget> {
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _title(),
          const SizedBox(height: 3),
          _body(),
        ],
      );

  Widget _title() => Container(
        height: 22,
        padding: const EdgeInsets.only(left: 3),
        child: SelectableText(
          widget.title,
          style: TextStyle(
            fontSize: 13,
            height: 22 / 13,
          ),
        ),
      );

  Widget _body() => ShimmerLoading(
        isLoading: widget.isLoading,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: ClickableContainer(
            enabled: widget.isEnabled,
            height: 150,
            onTap: widget.onTap,
            alignment: Alignment.centerLeft,
            color: widget.isLoading || widget.list.isEmpty ? AppColors.bgPaper : Colors.transparent,
            hoverColor: AppColors.bgHover,
            child: Builder(
              builder: (_) {
                if (widget.isLoading) return _loading();
                if (widget.list.isEmpty) return _emptyBuilder();
                if (widget.list.isNotEmpty) return _listBuilder();
                return Container();
              },
            ),
          ),
        ),
      );

  Widget _emptyBuilder() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/creatures/skeleton.gif'),
          const SizedBox(width: 10),
          const Text(
            'Waiting for data...',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      );

  Widget _loading() => Center(
        child: Container(
          height: 150,
          width: 150,
          padding: const EdgeInsets.all(50),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ),
      );

  Widget _listBuilder() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.list.isNotEmpty) _item(0),
          if (widget.list.length >= 2) _item(1),
          if (widget.list.length >= 3) _item(2),
          if (widget.list.length >= 4) _item(3),
          if (widget.list.length >= 5) _item(4),
        ],
      );

  Widget _item(int index) {
    HighscoresEntry item = widget.list[index];
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      color: index.isOdd ? AppColors.bgPaper : AppColors.bgPaper.withValues(alpha: 0.5),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    _itemRank(item),
                    if (item.isOnline) _onlineIndicator(),
                  ],
                ),
                const SizedBox(width: 2),
                _itemName(item),
                const SizedBox(width: 2),
                if (MediaQuery.of(context).size.width >= 1280) _itemWorld(item),
                if (MediaQuery.of(context).size.width >= 1280) const SizedBox(width: 10),
                _itemValue(item),
              ],
            ),
          ),
          if (widget.showBar) const SizedBox(height: 3),
          if (widget.showBar) _bar(item),
        ],
      ),
    );
  }

  Widget _itemRank(HighscoresEntry item) => Text(
        '${item.rank}.',
        style: TextStyle(
          fontSize: 11,
          height: 17 / 11,
          color: item.isOnline ? Colors.transparent : AppColors.textSecondary.withValues(alpha: 0.5),
        ),
      );

  Widget _onlineIndicator() => const Padding(
        padding: EdgeInsets.only(bottom: 1),
        child: BlinkingCircle(),
      );

  Widget _itemWorld(HighscoresEntry item) => Text(
        item.world?.name ?? '',
        style: TextStyle(
          fontSize: 11,
          height: 17 / 11,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
        ),
      );

  Widget _itemName(HighscoresEntry item) => Expanded(
        child: Text(
          item.name ?? '',
          maxLines: 1,
          style: const TextStyle(
            fontSize: 11,
            height: 17 / 11,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );

  Widget _itemValue(HighscoresEntry item) => BetterText(
        widget.customValueText?.call(item) ?? item.stringValue ?? '',
        selectable: false,
        style: TextStyle(
          fontSize: 11,
          height: 17 / 11,
          color: _valueColor(item),
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _bar(HighscoresEntry item) {
    final int top = widget.topValue ?? widget.list.first.value ?? 0;
    final int current = item.value ?? 0;
    double fraction = top <= 0 ? 0 : current / top;
    if (current > 0 && fraction < 0.03) fraction = 0.03;
    fraction = fraction.clamp(0.0, 1.0);

    return SizedBox(
      height: 4,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgDefault,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: fraction,
              child: Container(
                decoration: BoxDecoration(
                  color: _valueColor(item),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _valueColor(HighscoresEntry item) {
    final int top = widget.topValue ?? widget.list.first.value ?? 0;
    final int current = item.value ?? 0;

    final double t = top <= 0 ? 0 : (current / top).clamp(0.0, 1.0);
    return Color.lerp(widget.barColorLast, widget.barColorFirst, t)!;
  }
}
