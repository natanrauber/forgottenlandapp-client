import 'package:flutter/material.dart';
import 'package:forgottenlandapp_utils/utils.dart';
import 'package:get/get.dart';

import '../modules/about/about_page.dart';
import '../modules/bazaar/views/bazaar_page.dart';
import '../modules/books/views/books_page.dart';
import '../modules/character/character.dart';
import '../modules/highscores/highscores.dart';
import '../modules/home/home.dart';
import '../modules/live_streams/views/live_streams_page.dart';
import '../modules/npcs/views/npcs_page.dart';
import '../modules/online/online.dart';
import '../modules/shared/views/pages/splash_page.dart';
import '../modules/user/user.dart';

class MyPage extends GetPage<dynamic> {
  MyPage(
    String name,
    Widget page,
  ) : super(
          name: name,
          page: () => page,
          transition: Transition.noTransition,
          transitionDuration: Duration.zero,
        );
}

class Routes {
  static final MyPage bazaar = MyPage('/bazaar', BazaarPage());
  static final MyPage books = MyPage('/books', BooksPage());
  static final MyPage character = MyPage('/character', CharacterPage());
  static final MyPage guild = MyPage('/guild', AboutPage());
  static final MyPage highscores = MyPage('/highscores', const HighscoresPage());
  static final MyPage home = MyPage('/home', HomePage());
  static final MyPage livestreams = MyPage('/livestreams', LiveStreamsPage());
  static final MyPage login = MyPage('/login', LoginPage());
  static final MyPage npcs = MyPage('/npcs', NpcsPage());
  static final MyPage online = MyPage('/online', OnlineCharactersPage());
  static final MyPage splash = MyPage('/splash', SplashPage());

  static List<MyPage> getPages() {
    final List<MyPage> list = <MyPage>[
      bazaar,
      books,
      character,
      guild,
      highscores,
      home,
      livestreams,
      login,
      npcs,
      online,
      splash,
    ];

    for (final String c in LIST.category) {
      String name = '/highscores/${c.toLowerCase().replaceAll(' ', '')}';
      Widget page = HighscoresPage(category: c);

      if (c == 'Experience gained' || c == 'Online time') {
        for (final String p in LIST.timeframe) {
          name = '/highscores/$c/$p'.toLowerCase().replaceAll(' ', '');
          page = HighscoresPage(category: c, timeframe: p);
          final MyPage route = MyPage(name, page);
          list.add(route);
        }
      } else {
        final MyPage route = MyPage(name, page);
        list.add(route);
      }
    }

    return list;
  }
}
