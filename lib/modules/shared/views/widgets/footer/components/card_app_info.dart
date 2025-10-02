import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../../main.dart' show appVersion;

class CardAppInfo extends StatefulWidget {
  const CardAppInfo({super.key});

  @override
  State<CardAppInfo> createState() => _CardAppInfoState();
}

class _CardAppInfoState extends State<CardAppInfo> {
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
            TextSpan(
              text: 'Forgotten Land App © 2021 - ${DT.tibia.now().year}',
            ),

            TextSpan(
              text: ' (v$appVersion)',
              style: const TextStyle(color: AppColors.textSecondary),
            ),

            const TextSpan(
              text: '\nThe game ',
            ),

            TextSpan(
              text: 'Tibia',
              style: const TextStyle(
                color: AppColors.blue,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.blue,
              ),
              recognizer: TapGestureRecognizer()..onTap = () => launchUrlString('https://www.tibia.com/'),
            ),

            const TextSpan(
              text: ' and some images contained on this website are property of ',
            ),

            TextSpan(
              text: 'CipSoft GmbH',
              style: const TextStyle(
                color: AppColors.blue,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.blue,
              ),
              recognizer: TapGestureRecognizer()..onTap = () => launchUrlString('https://www.cipsoft.com/'),
            ),

            const TextSpan(
              text: '.',
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
}
