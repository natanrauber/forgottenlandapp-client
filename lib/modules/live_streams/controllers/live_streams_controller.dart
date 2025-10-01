import 'package:forgottenlandapp_adapters/adapters.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';

import '../../../controllers/controller.dart';
import '../../../main.dart';

class LiveStreamsController extends Controller {
  LiveStreamsController(this.httpClient);

  final IHttpClient httpClient;

  List<LiveStream> streams = <LiveStream>[];
  MyHttpResponse response = MyHttpResponse();

  Future<MyHttpResponse?> getStreams() async {
    if (isLoading.value) return null;
    isLoading.value = true;
    streams.clear();

    response = await httpClient.get('${env[EnvVar.pathForgottenLandApi]}/livestreams');

    if (response.success && response.dataAsMap['data'] is List) {
      for (final dynamic e in response.dataAsMap['data'] as List<dynamic>) {
        if (e is Map<String, dynamic>) streams.add(LiveStream.fromJson(e));
      }
    }

    isLoading.value = false;
    return response;
  }
}
