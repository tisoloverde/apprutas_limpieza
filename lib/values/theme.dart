import 'package:flutter/material.dart';

import 'package:solo_verde/values/colors.dart' as colors;

final ThemeData theme = ThemeData(
  primaryColor: colors.primary,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: colors.secondary),
  scaffoldBackgroundColor: colors.background,
  appBarTheme: const AppBarTheme(
    color: colors.background,
    iconTheme: IconThemeData(
      color: colors.secondary,
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: colors.primary,
    disabledColor: colors.disabled,
  ),
);
