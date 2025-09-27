import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'modules/main/app_binding.dart';
import 'theme/theme.dart';
import 'utils/utils.dart';
import 'package:get/get.dart';

class ForgottenLand extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: 'Forgotten Land',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        initialRoute: Routes.splash.name,
        initialBinding: AppBinding(),
        getPages: Routes.getPages(),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: <PointerDeviceKind>{
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
          },
        ),
      );
}
