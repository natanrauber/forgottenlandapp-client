import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:forgottenlandapp_designsystem/designsystem.dart';
import 'package:forgottenlandapp_utils/utils.dart';

import 'widgets.dart';

class OverviewAll extends StatefulWidget {
  const OverviewAll({super.key});

  @override
  State<OverviewAll> createState() => _OverviewAllState();
}

class _OverviewAllState extends State<OverviewAll> {
  Timer? _sinceSaveTimer;

  @override
  void initState() {
    super.initState();
    _sinceSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _sinceSaveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Shimmer(
        child: Container(
          // width: 400,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.bgDefault,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: <Widget>[
              _sinceServerSave(),
              const SizedBox(height: 12),
              OverviewExpgain(),
              const SizedBox(height: 20),
              OverviewOnlinetime(),
              const SizedBox(height: 20),
              OverviewRookmaster(),
              const SizedBox(height: 20),
              OverviewExperience(),
              const SizedBox(height: 20),
              OverviewOnline(),
            ],
          ),
        ),
      );

  Widget _sinceServerSave() => Text(
        _sinceServerSaveValue,
        maxLines: 1,
        textAlign: TextAlign.right,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          height: 22 / 11,
          color: AppColors.textSecondary.withValues(alpha: 0.8),
        ),
      );

  String get _sinceServerSaveValue {
    final DateTime tibiaNow = DT.tibia.now();
    final String hours = tibiaNow.hour.toString().padLeft(2, '0');
    final String minutes = tibiaNow.minute.toString().padLeft(2, '0');
    return '${hours}h${minutes}m since last server save';
  }
}
