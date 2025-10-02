import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../utils/utils.dart';
import '../../../character/controllers/character_controller.dart';

class AuctionWidget extends StatefulWidget {
  const AuctionWidget(this.item);

  final Auction item;

  @override
  State<AuctionWidget> createState() => _AuctionWidgetState();
}

class _AuctionWidgetState extends State<AuctionWidget> {
  final CharacterController characterCtrl = Get.find<CharacterController>();

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
            decoration: _decoration(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //
                      SizedBox(
                        height: 20,
                        child: Row(
                          children: <Widget>[
                            //
                            Image.asset('assets/icons/tibia_coin_trusted.png'),

                            const SizedBox(width: 4),

                            Expanded(child: _name()),
                          ],
                        ),
                      ),

                      _info('World: ${widget.item.world?.name ?? ''}'),

                      _info('Level: ${widget.item.level ?? ''}'),

                      if (widget.item.minimumBid != null)
                        _info('Minimum Bid: ${NumberFormat.decimalPattern().format(widget.item.minimumBid)}'),

                      if (widget.item.currentBid != null)
                        _info('Current Bid: ${NumberFormat.decimalPattern().format(widget.item.currentBid)}'),
                    ],
                  ),
                ),

                _infoIcons(context),
              ],
            ),
          ),
        ),
      );

  void _onTap() {
    dismissKeyboard(context);
    _openAuctionExternal();
  }

  BoxDecoration _decoration(BuildContext context) => BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.bgPaper),
      );

  Widget _name() => Text(
        widget.item.name ?? '',
        style: const TextStyle(
          height: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _info(String text) => Container(
        margin: const EdgeInsets.only(top: 5),
        child: BetterText(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      );

  Widget _infoIcons(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _battleyeTypeIcon(),
          _pvpType(),
        ],
      );

  Widget _infoIcon({required Widget child}) => Container(
        height: 20,
        margin: const EdgeInsets.only(bottom: 4),
        child: child,
      );

  Widget _battleyeTypeIcon() => _infoIcon(
        child: Image.asset(
          'assets/icons/battleye_type/${widget.item.world?.battleyeType?.toLowerCase()}.png',
        ),
      );

  Widget _pvpType() => _infoIcon(
        child: Image.asset(
          'assets/icons/pvp_type/${widget.item.world?.pvpType?.toLowerCase().replaceAll(' ', '_')}.png',
        ),
      );

  Future<void> _openAuctionExternal() async {
    if (widget.item.url == null) return;
    launchUrlString(widget.item.url!);
  }
}
