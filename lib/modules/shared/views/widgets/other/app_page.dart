import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../core/routes.dart';
import '../../../../../utils/utils.dart';
import '../../../../home/home.dart';
import '../../../../home/views/widgets/features_menu.dart';
import '../../../../main/app_controller.dart';
import '../../../../settings/controllers/settings_controller.dart';
import '../../../../settings/models/feature_model.dart';
import '../../../controllers/worlds_controller.dart';
import '../footer/app_footer.dart';
import '../header/app_header.dart';

class AppPage extends StatefulWidget {
  const AppPage({
    required this.screenName,
    this.body,
    this.topWidget,
    this.postFrameCallback,
    this.onRefresh,
    this.onNotification,
    this.padding = const EdgeInsets.fromLTRB(12, 12, 12, 60),
    this.canPop = true,
    this.maxWidth = 800,
    this.fullScreen = false,
  });

  final String screenName;
  final Widget? body;
  final Widget? topWidget;
  final Future<void> Function()? postFrameCallback;
  final Future<void> Function()? onRefresh;
  final bool Function(ScrollNotification)? onNotification;
  final EdgeInsetsGeometry? padding;
  final bool canPop;
  final double maxWidth;
  final bool fullScreen;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  AppController appCtrl = Get.find<AppController>();
  final HomeController homeCtrl = Get.find<HomeController>();
  SettingsController settingsCtrl = Get.find<SettingsController>();
  final WorldsController worldsCtrl = Get.find<WorldsController>();

  ScreenshotController screenshotCtrl = ScreenshotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appCtrl.ensureSplashIsVisited();
      if (appCtrl.visitedSplash) {
        _logScreenEvent();
        if (!_featureDisabled) widget.postFrameCallback?.call();
      }
    });
  }

  void _logScreenEvent() => FirebaseAnalytics.instance.logEvent(name: 'page_${widget.screenName}');

  Future<void> _onRefresh() async {
    await Future.wait(<Future<dynamic>>[
      settingsCtrl.getFeatures(force: true),
      worldsCtrl.getWorlds(force: true),
      homeCtrl.getOverview(),
      if (widget.onRefresh != null) widget.onRefresh!(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: widget.canPop,
      child: Screenshot(
        controller: screenshotCtrl,
        child: GestureDetector(
          onTap: () => dismissKeyboard(context),
          child: Scaffold(
            appBar: AppHeader(screenshotCtrl: screenshotCtrl),
            body: Container(
              height: height,
              width: width,
              decoration: _backgroundDecoration,
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: NotificationListener<ScrollNotification>(
                  onNotification: widget.onNotification,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: width >= 600 ? EdgeInsets.fromLTRB(16, 16, 16, 0) : EdgeInsets.zero,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (MediaQuery.of(context).size.width >= 800) ...<Widget>[
                          FeaturesMenu(),
                          const SizedBox(width: 16),
                        ],
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: <Widget>[
                              if (widget.topWidget != null) ...<Widget>[
                                widget.topWidget!,
                                const SizedBox(height: 12),
                              ],
                              Container(
                                decoration: _bodyDecoration,
                                child: Column(
                                  children: <Widget>[
                                    SingleChildScrollView(
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: widget.padding,
                                      child: Container(
                                        constraints: _bodyConstraints,
                                        child: _featureDisabled ? _disabledPageBody() : widget.body ?? Container(),
                                      ),
                                    ),
                                    AppFooter(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (MediaQuery.of(context).size.width >= 1000) ...<Widget>[
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: OverviewAll(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _featureDisabled {
    final String? routeName = Get.rawRoute?.settings.name?.toLowerCase();
    for (final Feature e in settingsCtrl.features) {
      if (e.name != null && routeName?.contains(e.name!.toLowerCase()) == true && !e.enabled) return true;
    }
    return false;
  }

  Widget _disabledPageBody() => Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            SelectableText.rich(
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
                    text: 'Feature temporarily disabled\n',
                  ),

                  TextSpan(
                    text: 'Go to homepage',
                    style: const TextStyle(
                      color: AppColors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.blue,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed<dynamic>(Routes.home.name),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  BoxDecoration get _backgroundDecoration => const BoxDecoration(
        color: AppColors.black,
        image: DecorationImage(
          image: AssetImage('assets/images/background/offline.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      );

  BoxDecoration get _bodyDecoration {
    final double width = MediaQuery.of(context).size.width;
    final double borderRadius = (width >= widget.maxWidth) ? 6 : 0;

    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      ),
      color: AppColors.bgDefault,
    );
  }

  BoxConstraints get _bodyConstraints {
    final double height = MediaQuery.of(context).size.height;
    final double appBarHeight = AppHeader().preferredSize.height;
    final double verticalPadding = widget.padding?.along(Axis.vertical) ?? 0;

    return BoxConstraints(
      minHeight: height - appBarHeight - verticalPadding,
    );
  }
}
