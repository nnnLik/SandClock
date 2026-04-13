import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';

Future<Color?> showSandColorPickerDialog({
  required BuildContext context,
  required Color current,
}) {
  return showDialog<Color>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text(AppStrings.sandColorTitle),
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: AppColors.sandPresets
            .map(
              (c) => GestureDetector(
                onTap: () => Navigator.of(ctx).pop(c),
                child: CircleAvatar(
                  backgroundColor: c,
                  radius: AppConstants.colorPickerAvatarRadius,
                  child: current == c
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              ),
            )
            .toList(),
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
