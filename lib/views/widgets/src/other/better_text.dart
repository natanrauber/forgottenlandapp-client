import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

Map<String, Map<String, dynamic>> _tags = <String, Map<String, dynamic>>{
  '<sb>': <String, dynamic>{
    'regex': '<sb>(.*?)<sb>',
    'style': const TextStyle(fontWeight: FontWeight.w600),
  },
  '<b>': <String, dynamic>{
    'regex': '<b>(.*?)<b>',
    'style': const TextStyle(fontWeight: FontWeight.w700),
  },
  '<primary>': <String, dynamic>{
    'regex': '<primary>(.*?)<primary>',
    'style': const TextStyle(color: AppColors.primary, decorationColor: AppColors.primary),
  },
  '<p>': <String, dynamic>{
    'regex': '<p>(.*?)<p>',
    'style': const TextStyle(color: AppColors.primary, decorationColor: AppColors.primary),
  },
  '<blue>': <String, dynamic>{
    'regex': '<blue>(.*?)<blue>',
    'style': const TextStyle(color: AppColors.blue, decorationColor: AppColors.blue),
  },
  '<lBlue>': <String, dynamic>{
    'regex': '<lBlue>(.*?)<lBlue>',
    'style': const TextStyle(color: AppColors.lightBlue, decorationColor: AppColors.lightBlue),
  },
  '<green>': <String, dynamic>{
    'regex': '<green>(.*?)<green>',
    'style': const TextStyle(color: AppColors.green, decorationColor: AppColors.green),
  },
  '<yellow>': <String, dynamic>{
    'regex': '<yellow>(.*?)<yellow>',
    'style': const TextStyle(color: AppColors.yellow, decorationColor: AppColors.yellow),
  },
  '<orange>': <String, dynamic>{
    'regex': '<orange>(.*?)<orange>',
    'style': const TextStyle(color: Colors.orange, decorationColor: Colors.orange),
  },
  '<red>': <String, dynamic>{
    'regex': '<red>(.*?)<red>',
    'style': const TextStyle(color: AppColors.red, decorationColor: AppColors.red),
  },
  '<white>': <String, dynamic>{
    'regex': '<white>(.*?)<white>',
    'style': const TextStyle(color: Colors.white, decorationColor: Colors.white),
  },
  '<small>': <String, dynamic>{
    'regex': '<small>(.*?)<small>',
    'style': const TextStyle(fontSize: 12),
  },
  '<u>': <String, dynamic>{
    'regex': '<u>(.*?)<u>',
    'style': const TextStyle(decoration: TextDecoration.underline),
  },
  '<a>': <String, dynamic>{
    'regex': '<a>(.*?)<a>',
    'style': const TextStyle(
      color: AppColors.blue,
      decorationColor: AppColors.blue,
      decoration: TextDecoration.underline,
    ),
  },
};

/// This text support tags to change text style
///
/// * usage:
///   * `<tag>text<tag>`, e.g., `<b>text<b>`
/// * tags:
///   * semi-bold (w600): `<sb>text<sb>`
///   * bold (w700): `<b>text<b>`
///   * primary color: `<primary>text<primary>`
///   * blue: `<blue>text<blue>`
///   * green: `<green>text<green>`
///   * size 16: `<small>text<small>` TODO: make size tags dynamic
class BetterText extends StatelessWidget {
  const BetterText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.selectable = true,
    this.hyperlink,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final bool selectable; // overflow does not work with selectable
  final String? hyperlink;

  @override
  Widget build(BuildContext context) => selectable
      ? SelectableText.rich(
          _buildTextSpan(),
          textAlign: textAlign,
          textDirection: textDirection,
          maxLines: maxLines,
          style: style,
          scrollPhysics: const NeverScrollableScrollPhysics(),
        )
      : Text.rich(
          _buildTextSpan(),
          textAlign: textAlign,
          textDirection: textDirection,
          maxLines: maxLines,
          style: style,
        );

  TextSpan _buildTextSpan() {
    Pattern pattern;
    List<InlineSpan> children;

    pattern = RegExp(
      _tags.keys.map((String key) => _tags[key]!['regex'] as String).join('|'),
      multiLine: true,
    );
    children = <InlineSpan>[];

    _applyStyles(pattern, children);

    return TextSpan(style: style, children: children);
  }

  String _applyStyles(Pattern pattern, List<InlineSpan> children) => text.splitMapJoin(
        pattern,
        onMatch: (Match match) {
          String? formattedText = match[0];
          TextStyle newStyle = const TextStyle();
          GestureRecognizer? recognizer;

          for (final String tag in _tags.keys) {
            if (RegExp(_tags[tag]!['regex']! as String).hasMatch(match[0]!)) {
              formattedText = formattedText?.replaceAll(tag, '');
              newStyle = newStyle.merge(_tags[tag]!['style'] as TextStyle);
              if (tag == '<a>' && hyperlink != null) {
                recognizer = TapGestureRecognizer()..onTap = () => launchUrlString(hyperlink!);
              }
            }
          }

          if (formattedText != null && formattedText.isNotEmpty) {
            children.add(
              TextSpan(
                text: formattedText,
                style: newStyle,
                recognizer: recognizer,
              ),
            );
          }

          return '';
        },
        onNonMatch: (String text) {
          if (text.isNotEmpty) children.add(TextSpan(text: text, style: style));
          return '';
        },
      );
}
