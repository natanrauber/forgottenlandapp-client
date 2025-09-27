import 'package:flutter/material.dart';
import '../../../../controllers/highscores_controller.dart';
import '../../../../controllers/home_controller.dart';
import '../../../../theme/colors.dart';
import '../../../widgets/src/other/clickable_container.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SponsorCard extends StatefulWidget {
  @override
  State<SponsorCard> createState() => _SponsorCardState();
}

class _SponsorCardState extends State<SponsorCard> {
  final HighscoresController highscoresCtrl = Get.find<HighscoresController>();
  final HomeController homeCtrl = Get.find<HomeController>();

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
        child: const SelectableText(
          'Sponsor',
          style: TextStyle(
            fontSize: 14,
            height: 22 / 14,
          ),
        ),
      );

  Widget _body() => ClickableContainer(
        onTap: () => launchUrlString(
          'https://www.instagram.com/merighitintas',
          mode: LaunchMode.externalApplication,
        ),
        height: 143,
        padding: const EdgeInsets.all(1),
        color: AppColors.bgHover,
        hoverColor: AppColors.bgHover,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/sponsor/sponsor.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}
