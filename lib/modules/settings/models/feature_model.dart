import 'package:flutter/foundation.dart';

class Feature {
  Feature({this.name, this.enabled = false});

  Feature.fromJson(Map<String, dynamic> json) {
    if (json['name'] is String) name = json['name'] as String;
    if (json['enabled'] is bool) {
      enabled = json['enabled'] as bool;
    } else {
      enabled = false;
    }
    if (kDebugMode) enabled = true;
  }

  String? name;
  late bool enabled;
}
