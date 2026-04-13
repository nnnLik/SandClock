import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_theme_presets.dart';

Future<AppThemePreset?> showThemePickerDialog({
  required BuildContext context,
  required AppThemePreset current,
}) {
  return showDialog<AppThemePreset>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text(AppStrings.themeTitle),
      content: SizedBox(
        width: 320,
        child: ListView(
          shrinkWrap: true,
          children: AppThemePresets.all
              .map(
                (theme) => ListTile(
                  onTap: () => Navigator.of(ctx).pop(theme),
                  leading: CircleAvatar(backgroundColor: theme.sandColor),
                  title: Text(theme.name),
                  trailing: current.name == theme.name
                      ? const Icon(Icons.check)
                      : null,
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text(AppStrings.cancel),
        ),
      ],
    ),
  );
}
