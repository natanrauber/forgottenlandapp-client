import 'package:forgottenlandapp_adapters/adapters.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';

import '../main.dart';
import '../rxmodels/character_rxmodel.dart';
import '../views/widgets/widgets.dart';
import 'controller.dart';

class CharacterController extends Controller {
  CharacterController(this.httpClient);

  final IHttpClient httpClient;

  final TextController searchCtrl = TextController();
  RxCharacter character = Character().obs;
  MyHttpResponse response = MyHttpResponse();

  Future<void> searchCharacter() async {
    isLoading.value = true;
    character.value = Character();

    try {
      final String name = searchCtrl.text.toLowerCase();
      response = await httpClient.get('${env[EnvVar.pathForgottenLandApi]}/character/${name.replaceAll(' ', '%20')}');
      if (response.success) character.value = Character.fromJson(response.dataAsMap['data'] as Map<String, dynamic>);
    } catch (e) {
      customPrint(e, color: PrintColor.red);
    }

    isLoading.value = false;
  }
}
