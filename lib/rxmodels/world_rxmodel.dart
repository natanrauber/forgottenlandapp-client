import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class RxWorld extends Rx<World> {
  RxWorld(super.initial);
}

extension WorldExtension on World {
  /// Returns a `RxWorld` with [this] `World` as initial value.
  RxWorld get obs => RxWorld(this);
}
