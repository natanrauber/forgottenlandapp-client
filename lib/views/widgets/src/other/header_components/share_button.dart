import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../modules/main/app_controller.dart';
import '../../../../../theme/colors.dart';

class ShareButton extends StatefulWidget {
  const ShareButton({
    super.key,
    required this.screenshotCtrl,
  });

  final ScreenshotController? screenshotCtrl;

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  final AppController appCtrl = Get.find<AppController>();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 10),
        child: PopupMenuButton<Widget>(
          tooltip: 'Share',
          color: AppColors.bgPaper,
          icon: const Icon(
            Icons.share,
            color: AppColors.bgDefault,
          ),
          itemBuilder: (_) => <PopupMenuEntry<Widget>>[
            _copyUrlButton(),
            if (_allowScreenshot) _downloadScreenshotButton(),
            _shareAltButton(),
          ],
        ),
      );

  bool get _allowScreenshot {
    if (widget.screenshotCtrl == null) return false;
    return <TargetPlatform>[TargetPlatform.windows, TargetPlatform.macOS].contains(defaultTargetPlatform);
  }

  PopupMenuItem<Widget> _copyUrlButton() => PopupMenuItem<Widget>(
        onTap: appCtrl.copyUrl,
        child: const MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Row(
            children: <Widget>[
              Icon(
                CupertinoIcons.link,
                size: 20,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: 10),
              Text(
                'Copy link',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );

  PopupMenuItem<Widget> _downloadScreenshotButton() => PopupMenuItem<Widget>(
        onTap: () => appCtrl.shareScreenshot(widget.screenshotCtrl!),
        child: const MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Row(
            children: <Widget>[
              Icon(
                CupertinoIcons.photo_on_rectangle,
                size: 20,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: 10),
              Text(
                'Screenshot',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );

  PopupMenuItem<Widget> _shareAltButton() => PopupMenuItem<Widget>(
        onTap: () => SharePlus.instance.share(ShareParams(uri: Uri.base)),
        child: const MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Row(
            children: <Widget>[
              Icon(
                CupertinoIcons.share,
                size: 20,
                color: AppColors.textPrimary,
              ),
              SizedBox(width: 10),
              Text(
                'Share via...',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      );
}
