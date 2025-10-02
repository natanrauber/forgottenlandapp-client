import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:get/get.dart';

import '../../../../../../core/routes.dart';
import '../../../../../character/controllers/character_controller.dart';

class CardDonate extends StatefulWidget {
  const CardDonate({super.key});

  @override
  State<CardDonate> createState() => _CardDonateState();
}

class _CardDonateState extends State<CardDonate> {
  final CharacterController characterCtrl = Get.find<CharacterController>();

  bool expanded = false;

  @override
  Widget build(BuildContext context) => Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(12),
        decoration: _decoration,
        child: _body(),
      );

  BoxDecoration get _decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.bgPaper,
        ),
      );

  Widget _body() => SelectableText.rich(
        TextSpan(
          style: const TextStyle(
            fontSize: 12,
            height: 1.5,
            fontWeight: FontWeight.w200,
            color: AppColors.textSecondary,
          ),
          children: <InlineSpan>[
            //
            const TextSpan(
              text: 'Please consider supporting us.',
            ),

            if (!expanded)
              TextSpan(
                text: '\nSee more',
                style: const TextStyle(
                  color: AppColors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.blue,
                ),
                recognizer: TapGestureRecognizer()..onTap = () => setState(() => expanded = true),
              ),

            if (expanded)
              const TextSpan(
                text: ' You can do this by donating Tibia Coins to the character ',
              ),

            if (expanded)
              TextSpan(
                text: 'Awaken',
                style: const TextStyle(
                  color: AppColors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.blue,
                ),
                recognizer: TapGestureRecognizer()..onTap = _pushCharacterPage,
              ),

            if (expanded)
              const TextSpan(
                text:
                    '. Any donation is appreciated and will be put toward the costs of maintaining our website. Your character will also display a supporter badge on our website. Thank you!',
              ),

            if (expanded)
              TextSpan(
                text: '\nSee less',
                style: const TextStyle(
                  color: AppColors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.blue,
                ),
                recognizer: TapGestureRecognizer()..onTap = () => setState(() => expanded = false),
              ),
          ],
        ),
        textAlign: TextAlign.center,
      );

  Future<void> _pushCharacterPage() async {
    characterCtrl.searchCtrl.text = 'Awaken';
    Get.toNamed<dynamic>(Routes.character.name);
    characterCtrl.searchCharacter();
  }
}
