// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../theme/colors.dart';

/// [custom types]
typedef Keyboard = TextInputType?;
typedef Formatters = List<TextInputFormatter>?;
typedef Validator = String? Function(String?)?;
typedef OnChanged = void Function(String?)?;
typedef OnSaved = void Function(String?)?;
typedef TextController = TextEditingController;

/// [CustomTextField]
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.enabled = true,
    required this.label,
    required this.controller,
    this.prefixText,
    this.keyboardType = TextInputType.text,
    this.formatters,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onEditingComplete,
    this.obscureText = false,
    this.suffixIcon,
    this.loading = false,
  });

  final bool enabled;
  final String label;
  final TextController controller;
  final String? prefixText;
  final Keyboard keyboardType;
  final Formatters formatters;
  final Validator validator;
  final OnChanged onChanged;
  final OnSaved onSaved;
  final void Function()? onEditingComplete;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool loading;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          //
          Focus(
            child: TextFormField(
              enabled: enabled && !loading,
              controller: controller,
              obscureText: obscureText,
              decoration: _decoration,
              keyboardType: keyboardType,
              style: _textStyle,
              inputFormatters: formatters,
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: onChanged,
              onSaved: onSaved,
              onEditingComplete: onEditingComplete,
            ),
          ),

          if (suffixIcon != null && !loading) suffixIcon!,

          if (loading) _loading(),
        ],
      );

  Color get _color => enabled && !loading ? AppColors.textPrimary : AppColors.textSecondary;

  TextStyle get _textStyle => TextStyle(
        fontSize: 14,
        height: 1,
        color: _color,
      );

  InputDecoration get _decoration => InputDecoration(
        filled: true,
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        floatingLabelStyle: const TextStyle(
          fontSize: 14,
          height: 1,
          color: AppColors.primary,
        ),
        prefixText: prefixText,
        prefixStyle: _textStyle,
      );

  Widget _loading() => Container(
        margin: const EdgeInsets.only(right: 12),
        alignment: Alignment.centerRight,
        child: const SizedBox(
          height: 14,
          width: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.textSecondary,
          ),
        ),
      );
}
