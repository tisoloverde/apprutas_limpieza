import 'package:flutter/material.dart';

import 'package:solo_verde/values/colors.dart' as colors;
import 'package:solo_verde/values/dimens.dart' as dimens;

class InputText extends StatelessWidget {
  final Icon? icon;
  final String placeholder;
  final String? initialValue;
  final Function(String) onChange;
  final bool disabled;
  final TextEditingController? controller;
  final Function(String)? onEnter;

  const InputText({
    super.key,
    this.icon,
    this.placeholder = '',
    this.initialValue,
    required this.onChange,
    this.disabled = false,
    this.controller,
    this.onEnter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // border: Border.all(width: 2, color: colors.border),
        // borderRadius: BorderRadius.circular(dimens.radius),
        border: Border(
          bottom: BorderSide(
            color: colors.border,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.only(
        left: dimens.paddingButton,
        right: dimens.paddingButton,
      ),
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        enabled: !disabled,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          icon: icon,
          border: InputBorder.none,
          hintText: placeholder,
        ),
        // textAlign: TextAlign.center,
        onChanged: onChange,
        onFieldSubmitted: onEnter != null ? (val) => onEnter!(val) : null,
      ),
    );
  }
}
