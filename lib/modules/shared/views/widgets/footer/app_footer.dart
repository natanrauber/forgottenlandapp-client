import 'package:flutter/material.dart';
import 'components/card_app_info.dart';
import 'components/card_donate.dart';

class AppFooter extends AppBar {
  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  @override
  Widget build(BuildContext context) => const Column(
        children: <Widget>[
          SizedBox(height: 20),
          CardDonate(),
          SizedBox(height: 20),
          CardAppInfo(),
          SizedBox(height: 20),
        ],
      );
}
