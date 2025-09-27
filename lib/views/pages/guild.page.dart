import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../widgets/src/other/app_page.dart';

class GuildPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AppPage(
        screenName: 'about_fl',
        body: Column(
          children: <Widget>[
            //
            Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: <Widget>[
                  //
                  const SizedBox(height: 16),

                  Container(
                    height: 200,
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/logo.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _text(
                    'We live and fight for a forgotten land, where the first mysteries intrigued the first warriors. In time, many have left us, entering the depths of oblivion forever. Through this union, we forge eternal alliances, where we insert our name in history.',
                  ),

                  // const SizedBox(height: 20),

                  // _text(
                  //   'The guild was founded on Calmera on Apr 14 2020. It is currently active and always open for applications.',
                  // ),

                  // const SizedBox(height: 50),

                  // _viewOnTibiaWebsiteButton(),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _text(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: SelectableText(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.justify,
        ),
      );

  // Widget _itemBuilder(BuildContext context, int index) => ClickableContainer(
  //       onTap: () {
  //         if (MAP.instagram[LIST.member[index]] != null) {
  //           launchUrlString(
  //             MAP.instagram[LIST.member[index]]!,
  //           );
  //         }
  //       },
  //       width: 120,
  //       child: Image.asset('assets/outfit/${LIST.member[index]}.png'),
  //     );

  // Widget _viewOnTibiaWebsiteButton() => ClickableContainer(
  //       onTap: () => launchUrlString(
  //         'https://www.tibia.com/community/?subtopic=guilds&page=view&GuildName=Forgotten+Land',
  //       ),
  //       padding: const EdgeInsets.all(12),
  //       color: AppColors.bgPaper,
  //       hoverColor: AppColors.bgHover,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: const Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Text(
  //             'View on Tibia.com',
  //             style: TextStyle(
  //               fontSize: 13,
  //               color: AppColors.primary,
  //             ),
  //           ),
  //           Icon(
  //             CupertinoIcons.arrow_up_right_square,
  //             size: 18,
  //             color: AppColors.primary,
  //           ),
  //         ],
  //       ),
  //     );
}
