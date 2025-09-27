import 'package:flutter/material.dart';
import 'package:forgottenlandapp_models/models.dart';
import 'package:get/get.dart';

import '../../../theme/colors.dart';
import '../../../theme/theme.dart';
import '../../../views/widgets/src/other/app_page.dart';
import '../../../views/widgets/src/other/error_builder.dart';
import '../controllers/live_streams_controller.dart';
import 'components/stream_widget.dart';

class LiveStreamsPage extends StatefulWidget {
  @override
  State<LiveStreamsPage> createState() => _LiveStreamsPageState();
}

class _LiveStreamsPageState extends State<LiveStreamsPage> {
  LiveStreamsController liveStreamsCtrl = Get.find<LiveStreamsController>();

  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'live_streams',
        postFrameCallback: liveStreamsCtrl.getStreams,
        onRefresh: liveStreamsCtrl.getStreams,
        padding: const EdgeInsets.symmetric(vertical: 20),
        body: Column(
          children: <Widget>[
            _title(),
            _divider(),
            _description(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _body(),
            ),
          ],
        ),
      );

  Widget _title() => SelectableText(
        'Live streams',
        style: appTheme().textTheme.titleMedium,
      );

  Widget _divider() => Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: const Divider(height: 1),
      );

  Widget _description() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.bgPaper,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const SelectableText(
          'Live streams on Twitch containing the word "Rookgaard" in their title or tags will be shown here.',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      );

  Widget _body() => Obx(
        () {
          if (liveStreamsCtrl.isLoading.value) return _loading();
          if (liveStreamsCtrl.response.error) {
            return ErrorBuilder(
              'Internal server error',
              reloadButtonText: 'Try again',
              onTapReload: liveStreamsCtrl.getStreams,
            );
          }
          if (liveStreamsCtrl.streams.isEmpty) {
            return ErrorBuilder(
              'No live streams found',
              onTapReload: liveStreamsCtrl.getStreams,
            );
          }
          return _listBuilder();
        },
      );

  Widget _loading() => Center(
        child: Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(37.5),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ),
      );

  Widget _listBuilder() => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: liveStreamsCtrl.streams.length,
        itemBuilder: _itemBuilder,
      );

  Widget _itemBuilder(BuildContext context, int index) {
    final LiveStream entry = liveStreamsCtrl.streams[index];

    return Padding(
      padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
      child: StreamWidget(entry),
    );
  }
}
