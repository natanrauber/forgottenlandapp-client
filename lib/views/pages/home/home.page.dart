import 'package:flutter/material.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/online_controller.dart';
import 'components/news.widget.dart';
import 'components/overview_experience.dart';
import 'components/overview_expgain.dart';
import 'components/overview_online.dart';
import 'components/overview_onlinetime.dart';
import 'components/overview_rookmaster.dart';
import 'components/sponsor_card.dart';
import '../../widgets/src/home_screen_grid.widget.dart';
import '../../widgets/src/other/app_page.dart';
import '../../widgets/src/other/shimmer_loading.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeCtrl = Get.find<HomeController>();
  final OnlineController onlineCtrl = Get.find<OnlineController>();

  Future<void> _loadHomeData() async {
    if (homeCtrl.news.isEmpty) await homeCtrl.getNews();
    homeCtrl.getOverview();
    homeCtrl.runTimer();
  }

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'home',
        canPop: false,
        fullScreen: MediaQuery.of(context).size.width >= 1000,
        postFrameCallback: _loadHomeData,
        onRefresh: _loadHomeData,
        maxWidth: 860,
        topWidget: MediaQuery.of(context).size.width >= 1280 ? HomeScreenGrid() : null,
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

  Widget _bodyNarrow() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SponsorCard(),
          const SizedBox(height: 16, width: 16),
          OverviewExpgain(),
          const SizedBox(height: 16, width: 16),
          OverviewOnlinetime(),
          const SizedBox(height: 16, width: 16),
          NewsWidget(),
          const SizedBox(height: 16, width: 16),
          HomeScreenGrid(),
        ],
      );

  Widget _bodyMedium() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
              const SizedBox(height: 16, width: 16),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SponsorCard(),
                    const SizedBox(height: 16, width: 16),
                    NewsWidget(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16, width: 16),
          HomeScreenGrid(),
        ],
      );

  Widget _bodyWide() => Column(
        children: <Widget>[
          if (MediaQuery.of(context).size.width < 1280) HomeScreenGrid(),
          if (MediaQuery.of(context).size.width < 1280) const SizedBox(height: 16, width: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: OverviewOnline()),
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
              const SizedBox(height: 16, width: 16),
              Expanded(
                child: Column(
                  children: <Widget>[
                    SponsorCard(),
                    const SizedBox(height: 16, width: 16),
                    NewsWidget(),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
}
