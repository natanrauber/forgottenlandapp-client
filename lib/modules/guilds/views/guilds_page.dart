import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/guilds_controller.dart';
import '../../shared/controllers/worlds_controller.dart';
import '../../shared/views/widgets/header/app_header.dart';
import 'package:get/instance_manager.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GuildsHiddenPage extends StatefulWidget {
  @override
  State<GuildsHiddenPage> createState() => _GuildsHiddenPageState();
}

class _GuildsHiddenPageState extends State<GuildsHiddenPage> {
  final WorldsController worldsCtrl = Get.find<WorldsController>();
  final GuildsController guildsCtrl = Get.find<GuildsController>();

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (_) async {
  //       Alert.loading(context);
  //       await worldsCtrl.getWorlds().then(
  //         (_) async {
  //           await guildsCtrl.load(worldsCtrl.list).then((_) => Alert.pop(context));
  //         },
  //       );
  //     },
  //   );

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppHeader(),
        body: Center(
          child: RefreshIndicator(
            onRefresh: () async {},
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  /// highscores list view
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width > 1000 ? ((MediaQuery.of(context).size.width / 2) - 400) : 20,
                        20,
                        MediaQuery.of(context).size.width > 1000 ? ((MediaQuery.of(context).size.width / 2) - 400) : 20,
                        270,
                      ),
                      itemCount: guildsCtrl.list.length,
                      itemBuilder: _itemBuilder,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _itemBuilder(BuildContext context, int index) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrlString(
            'https://www.tibia.com/community/?subtopic=guilds&page=view&GuildName=${guildsCtrl.list[index].name}',
          ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 15),
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SelectableText(
                        guildsCtrl.list[index].name ?? '',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  const Icon(
                    CupertinoIcons.chevron_right,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
