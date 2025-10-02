import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:forgottenlandapp_adapters/adapters.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/controller.dart';
import '../../../main.dart';

class UserController extends Controller {
  UserController(this.httpClient);

  final IHttpClient httpClient;

  TextController nameCtrl = TextController();
  TextController passwordCtrl = TextController();
  TextController confirmPasswordCtrl = TextController();

  RxString? info;
  RxString? error;
  RxString? code;
  RxBool verified = false.obs;
  RxBool isLoggedIn = false.obs;
  Rx<User>? data;

  Future<void> signup() async {
    isLoading.value = true;
    error = null;
    code = null;
    verified = false.obs;

    if (passwordCtrl.text.length < 8) {
      error = 'Invalid password'.obs;
      isLoading.value = false;
      return;
    }
    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      error = "Passwords don't match".obs;
      isLoading.value = false;
      return;
    }

    try {
      final MyHttpResponse cr = await httpClient.get('${env[EnvVar.pathForgottenLandApi]}/character/${nameCtrl.text}');
      if (!cr.success) {
        error = 'Character not found'.obs;
        isLoading.value = false;
        return;
      }

      final MyHttpResponse response = await httpClient.post(
        '${env[EnvVar.pathForgottenLandApi]}/user/signup',
        <String, dynamic>{
          'name': nameCtrl.text,
          'secret': sha256.convert(utf8.encode(nameCtrl.text + passwordCtrl.text)).toString(),
        },
      );

      if (response.statusCode == 409) error = 'Already registered'.obs;
      if (response.statusCode == 500) error = 'Server error'.obs;
      if (response.success) code = (response.dataAsMap['data']['code'] as String).obs;
    } catch (e) {
      customPrint(e, color: PrintColor.red);
    }

    isLoading.value = false;
  }

  Future<void> verify() async {
    isLoading.value = true;

    try {
      final MyHttpResponse response = await httpClient.post(
        '${env[EnvVar.pathForgottenLandApi]}/user/verify',
        <String, dynamic>{
          'name': nameCtrl.text,
        },
      );

      if (response.statusCode == 404) error = 'Character not found'.obs;
      if (response.statusCode == 202) error = 'Already verified'.obs;
      if (response.statusCode == 406) error = 'Code not found in comment'.obs;
      if (response.statusCode == 500) error = 'Server error'.obs;
      if (response.statusCode == 200) {
        info = 'Verified!'.obs;
        verified = true.obs;
      }
    } catch (e) {
      customPrint(e, color: PrintColor.red);
    }

    isLoading.value = false;
  }

  Future<void> signin() async {
    isLoading.value = true;
    isLoggedIn.value = false;
    data = null;

    try {
      final MyHttpResponse response = await httpClient.post(
        '${env[EnvVar.pathForgottenLandApi]}/user/signin',
        <String, dynamic>{
          'name': nameCtrl.text,
          'secret': sha256.convert(utf8.encode(nameCtrl.text + passwordCtrl.text)).toString(),
        },
      );

      if (response.statusCode == 406) error = 'Invalid credentials'.obs;
      if (response.success) {
        nameCtrl.clear();
        passwordCtrl.clear();
        isLoggedIn.value = true;
        data = User.fromJson(response.dataAsMap['data'] as Map<String, dynamic>).obs;
        await SharedPreferences.getInstance().then(
          (SharedPreferences prefs) => prefs.setString('user', jsonEncode(data)),
        );
      }
    } catch (e) {
      customPrint(e, color: PrintColor.red);
    }

    isLoading.value = false;
  }

  Future<void> signout() async {
    isLoading.value = true;
    data = null;
    isLoggedIn.value = false;
    isLoading.value = false;
  }

  Future<void> retrieveSession() async {
    isLoading.value = true;
    isLoggedIn.value = false;
    data = null;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('user') == null) {
        isLoading.value = false;
        return;
      }

      final dynamic json = jsonDecode(prefs.getString('user')!);
      data = User.fromJson(json as Map<String, dynamic>).obs;
      isLoggedIn.value = true;
    } catch (e) {
      customPrint(e, color: PrintColor.red);
    }

    isLoading.value = false;
  }
}
