import 'package:flutter/material.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:get/get.dart';

import '../../../online/online.dart';
import '../../../shared/views/widgets/other/app_page.dart';
import '../../controllers/home_controller.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeCtrl = Get.find<HomeController>();
  final OnlineController onlineCtrl = Get.find<OnlineController>();

  Future<void> _loadHomeData() async {
    await homeCtrl.getNews();
    homeCtrl.runTimer();
  }

  Future<void> _refreshHomeData() async {
    await homeCtrl.getNews();
  }

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'home',
        canPop: false,
        fullScreen: MediaQuery.of(context).size.width >= 1000,
        postFrameCallback: _loadHomeData,
        onRefresh: _refreshHomeData,
        body: Shimmer(
          child: Builder(
            builder: (_) {
              if (MediaQuery.of(context).size.width >= 1000) return _bodyWide();
              if (MediaQuery.of(context).size.width >= 600) return _bodyMedium();
              return _bodyNarrow();
            },
          ),
        ),
      );

  Widget _bodyWide() => NewsWidget();

  Widget _bodyMedium() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: NewsWidget()),
          const SizedBox(height: 16, width: 16),
          Expanded(
            child: Column(
              children: <Widget>[
                OverviewExpgain(),
                const SizedBox(height: 16, width: 16),
                OverviewOnlinetime(),
                const SizedBox(height: 16, width: 16),
                OverviewRookmaster(),
                const SizedBox(height: 16, width: 16),
                OverviewExperience(),
              ],
            ),
          ),
        ],
      );

  Widget _bodyNarrow() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OverviewExpgain(),
          const SizedBox(height: 16, width: 16),
          OverviewOnlinetime(),
          const SizedBox(height: 16, width: 16),
          NewsWidget(),
          const SizedBox(height: 16, width: 16),
          HomeScreenGrid(),
        ],
      );
}
