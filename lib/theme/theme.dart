import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

ThemeData appTheme() => ThemeData(
      brightness: Brightness.light,

      fontFamily: 'MartianMono',

      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.primary,

      colorScheme: const ColorScheme(
        primary: AppColors.primary,
        secondary: AppColors.yellow,
        surface: AppColors.bgDefault,
        error: AppColors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onError: Colors.white,
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: AppColors.bgDefault,

      iconTheme: const IconThemeData(color: AppColors.primary),

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppColors.primary,
      ),

      /// text theme
      textTheme: const TextTheme(
        //
        titleMedium: TextStyle(
          fontSize: 16,
          height: 22 / 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),

        bodyMedium: TextStyle(
          fontSize: 14,
          height: 22 / 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
      ),

      /// selected text
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary,
        selectionHandleColor: AppColors.primary,
      ),

      /// text input
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: AppColors.bgPaper,
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: AppColors.primary),
        floatingLabelStyle: TextStyle(color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.bgPaper),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.bgPaper),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.bgPaper),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.bgPaper),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.red),
        ),
      ),

      /// dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: AppColors.bgPaper,
      ),
    );
