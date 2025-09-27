import 'package:forgottenlandapp_adapters/adapters.dart';
import 'package:forgottenlandapp_models/models.dart';

import '../utils/src/paths.dart';
import 'controller.dart';

class GuildsController extends Controller {
  GuildsController(this.httpClient);

  final IHttpClient httpClient;

  final List<Guild> list = <Guild>[];

  Future<bool> load(List<World> worlds) async {
    list.clear();

    MyHttpResponse response;

    for (final World world in worlds) {
      response = await httpClient.get('${PATH.tibiaDataApi}/guilds/${world.name}');

      final WorldGuilds worldGuildList = WorldGuilds.fromJson(response.dataAsMap);

      for (final Active activeGuild in worldGuildList.guilds?.active ?? <Active>[]) {
        response = await httpClient.get('${PATH.tibiaDataApi}/guild/${activeGuild.name}.json');

        final Guild guild = Guild.fromJson(response.dataAsMap);

        if (guild.rookerGuild == true) {
          list.add(guild);
          update();
        }
      }
    }

    return true;
  }
}
