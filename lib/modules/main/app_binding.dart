import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:forgottenlandapp_adapters/adapters.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get.dart';

import '../character/controllers/character_controller.dart';
import '../guilds/controllers/guilds_controller.dart';
import '../highscores/controllers/highscores_controller.dart';
import '../home/controllers/home_controller.dart';
import '../online/controllers/online_controller.dart';
import '../user/controllers/user_controller.dart';
import '../shared/controllers/worlds_controller.dart';
import '../../main.dart';
import '../bazaar/controllers/bazaar_controller.dart';
import '../books/controllers/books_controller.dart';
import '../live_streams/controllers/live_streams_controller.dart';
import '../npcs/controllers/npcs_controller.dart';
import '../settings/controllers/settings_controller.dart';
import 'app_controller.dart';

class AppBinding implements Bindings {
  final IDatabaseClient _databaseClient = MySupabaseClient(
    databaseKey: env[EnvVar.databaseKey]!,
    databaseUrl: env[EnvVar.databaseUrl]!,
  );
  final IHttpClient _httpClient = MyDioClient(postRequestCallback: _postRequestCallback);

  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(UserController(_httpClient));
    Get.put(HomeController(_httpClient));
    Get.put(CharacterController(_httpClient));
    Get.put(WorldsController(_httpClient));
    Get.put(GuildsController(_httpClient));
    Get.put(OnlineController(_httpClient));
    Get.put(HighscoresController(_databaseClient, _httpClient));
    Get.put(BazaarController(httpClient: _httpClient, worldsCtrl: Get.find<WorldsController>()));
    Get.put(SettingsController(_httpClient));
    Get.put(LiveStreamsController(_httpClient));
    Get.put(BooksController(_httpClient));
    Get.put(NpcsController(_httpClient));
  }
}

Future<void> _postRequestCallback(MyHttpResponse response) async => FirebaseAnalytics.instance.logEvent(
      name: _eventName(response),
      parameters: <String, Object>{
        'data': response.dataAsMap.toString(),
      },
    );

String _eventName(MyHttpResponse response) {
  final int? statusCode = response.statusCode;
  String? path = response.requestOptions?.path;
  if (statusCode == null || path == null) return 'invalid response';

  // remove unecessary info (name has to be as short as possible)
  path = path.replaceAll('//', '').replaceFirst('/', 'SPLIT').split('SPLIT').last;
  path = path.replaceAll('highscores', 'hs');
  path = path.replaceAll('experiencegained', 'expgain');
  if (path.contains('character/')) path = 'character/';
  if (path.contains('npcs/')) path = 'npcs/';
  return '$statusCode /$path';
}
