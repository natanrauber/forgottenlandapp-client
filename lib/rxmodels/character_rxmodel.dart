import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class RxCharacter extends Rx<Character> {
  RxCharacter(super.initial);
}

extension CharacterExtension on Character {
  /// Returns a `RxCharacter` with [this] `Character` as initial value.
  RxCharacter get obs => RxCharacter(this);
}
