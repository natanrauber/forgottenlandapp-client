import 'package:forgottenlandapp_adapters/adapters.dart';
import 'package:forgottenlandapp_utils/utils.dart';

import '../../../controllers/controller.dart';
import '../../../main.dart';
import '../models/feature_model.dart';

class SettingsController extends Controller {
  SettingsController(this.httpClient);

  final IHttpClient httpClient;

  List<Feature> features = <Feature>[];

  Future<MyHttpResponse?> getFeatures() async {
    if (isLoading.value) return null;
    if (features.isNotEmpty) return null;

    isLoading.value = true;

    final MyHttpResponse response = await httpClient.get('${env[EnvVar.pathForgottenLandApi]}/settings/features');

    if (response.success && response.dataAsMap['data'] is List) {
      for (final dynamic e in response.dataAsMap['data'] as List<dynamic>) {
        if (e is Map<String, dynamic>) features.add(Feature.fromJson(e));
      }
    }

    isLoading.value = false;
    return response;
  }
}
