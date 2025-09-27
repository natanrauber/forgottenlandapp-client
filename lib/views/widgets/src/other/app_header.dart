import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../modules/main/app_controller.dart';
import '../../../../utils/utils.dart';
import '../images/svg_image.dart';
import 'header_components/account_button.dart';
import 'header_components/share_button.dart';

class AppHeader extends AppBar {
  AppHeader({
    this.returnButton = true,
    this.actionButtons,
    this.screenshotCtrl,
  });

  final bool returnButton;
  final List<Widget>? actionButtons;
  final ScreenshotController? screenshotCtrl;

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  final AppController appCtrl = Get.find<AppController>();
  final UserController userCtrl = Get.find<UserController>();

  @override
  Widget build(BuildContext context) => AppBar(
        title: _logo(),
        automaticallyImplyLeading: false,
        leading: const AccountButton(),
        actions: <Widget>[
          ShareButton(
            screenshotCtrl: widget.screenshotCtrl,
          ),
        ],
      );

  Widget _logo() => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _pushHomeScreen,
          child: const SvgImage(
            asset: 'assets/svg/logo.svg',
            height: 60,
          ),
        ),
      );

  void _pushHomeScreen() {
    if (ModalRoute.of(context)?.settings.name != Routes.home.name) Get.toNamed<dynamic>(Routes.home.name);
  }
}
