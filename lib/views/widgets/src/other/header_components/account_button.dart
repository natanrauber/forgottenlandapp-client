import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../theme/colors.dart';
import '../../../../../utils/src/routes.dart';

class AccountButton extends StatefulWidget {
  const AccountButton({super.key});

  @override
  State<AccountButton> createState() => _AccountButtonState();
}

class _AccountButtonState extends State<AccountButton> {
  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _pushLoginScreen,
          child: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Icon(
              Icons.person,
              color: AppColors.bgDefault,
            ),
          ),
        ),
      );

  void _pushLoginScreen() {
    if (ModalRoute.of(context)?.settings.name != Routes.login.name) Get.toNamed<dynamic>(Routes.login.name);
  }
}
