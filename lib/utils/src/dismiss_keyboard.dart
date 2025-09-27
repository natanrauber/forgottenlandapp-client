// Flutter imports:
import 'package:flutter/material.dart';

/// [dismiss keyboard]
/// calls [unfocus()] on the focused widget that is using keyboard
void dismissKeyboard(BuildContext context) => FocusScope.of(context).unfocus();
