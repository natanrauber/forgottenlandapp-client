import 'package:get/get.dart';

abstract class Controller extends GetxController {
  RxBool isLoading = false.obs;
}
