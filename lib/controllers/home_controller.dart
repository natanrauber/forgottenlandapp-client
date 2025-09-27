import 'dart:async';

import 'package:forgottenlandapp_adapters/adapters.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get.dart';

import '../utils/src/paths.dart';
import '../utils/src/routes.dart';
import 'controller.dart';

class HomeController extends Controller {
  HomeController(this.httpClient);

  final IHttpClient httpClient;

  RxList<News> news = <News>[].obs;
  RxList<HighscoresEntry> overviewExpgain = <HighscoresEntry>[].obs;
  RxList<HighscoresEntry> overviewOnlinetime = <HighscoresEntry>[].obs;
  RxList<HighscoresEntry> overviewRookmaster = <HighscoresEntry>[].obs;
  RxList<HighscoresEntry> overviewExperience = <HighscoresEntry>[].obs;
  RxList<HighscoresEntry> overviewOnline = <HighscoresEntry>[].obs;

  Timer? timerOverview;
  Timer? timerNews;

  Future<MyHttpResponse> getNews({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    final MyHttpResponse response = await httpClient.get('${PATH.tibiaDataApi}/news/latest');

    if (response.success) {
      final List<News> aux = <News>[];
      for (final dynamic item in response.dataAsMap['news'] as List<dynamic>) {
        aux.add(News.fromJson(item as Map<String, dynamic>));
      }
      news.value = aux.toList();
    }

    isLoading.value = false;
    return response;
  }

  Future<MyHttpResponse> getOverview() async {
    isLoading.value = true;

    final MyHttpResponse response = await httpClient.get('${PATH.forgottenLandApi}/highscores/overview');

    if (response.success) {
      final Overview overview = Overview.fromJson(
        (response.dataAsMap['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      );
      overviewExpgain.value = overview.experiencegained.toList();
      overviewOnlinetime.value =
          overview.onlinetime.map((OnlineEntry e) => HighscoresEntry.fromOnlineEntry(e)).toList();
      overviewRookmaster.value = overview.rookmaster.toList();
      overviewExperience.value = overview.experience.toList();
      overviewOnline.value = overview.online.map((OnlineEntry e) => HighscoresEntry.fromOnlineEntry(e)).toList();
    }

    isLoading.value = false;
    return response;
  }

  void runTimer() {
    if (timerOverview == null) {
      timerOverview = Timer.periodic(
        const Duration(minutes: 5),
        (_) {
          if (Get.currentRoute != Routes.home.name) return;
          if (isLoading.value) return;
          getOverview();
        },
      );
      customPrint('Periodic timer started: overview [5 min]');
    }
    if (timerNews == null) {
      timerNews = Timer.periodic(
        const Duration(hours: 1),
        (_) async {
          if (Get.currentRoute != Routes.home.name) return;
          do {
            await Future<dynamic>.delayed(const Duration(seconds: 5));
          } while (isLoading.value);
          getNews(showLoading: false);
        },
      );
      customPrint('Periodic timer started: news [1 hour]');
    }
  }
}
